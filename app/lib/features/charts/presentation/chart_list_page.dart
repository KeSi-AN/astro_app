import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../../core/format/formatters.dart';
import '../data/chart_repository.dart';
import '../domain/chart_entry.dart';

class ChartListState {
  const ChartListState({this.query = '', this.charts, this.error});
  final String query;
  final List<ChartEntry>? charts; // null while loading
  final Object? error;
}

class ChartListCubit extends Cubit<ChartListState> {
  ChartListCubit(this._repo) : super(const ChartListState()) {
    _listen('');
  }

  final ChartRepository _repo;
  StreamSubscription<List<ChartEntry>>? _sub;

  void search(String query) {
    emit(ChartListState(query: query, charts: state.charts));
    _listen(query);
  }

  void _listen(String query) {
    _sub?.cancel();
    _sub = _repo.watchAll(search: query).listen(
          (c) => emit(ChartListState(query: query, charts: c)),
          onError: (Object e) => emit(ChartListState(query: query, error: e)),
        );
  }

  Future<int> duplicate(int id) => _repo.duplicate(id);
  Future<void> delete(int id) => _repo.delete(id);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

class ChartListPage extends StatelessWidget {
  const ChartListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartListCubit(context.read<AppServices>().charts),
      child: const _ChartListView(),
    );
  }
}

class _ChartListView extends StatelessWidget {
  const _ChartListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or place',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: context.read<ChartListCubit>().search,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.newChart),
        icon: const Icon(Icons.add),
        label: const Text('New chart'),
      ),
      body: BlocBuilder<ChartListCubit, ChartListState>(
        builder: (context, state) {
          if (state.error != null) {
            return Center(child: Text('Could not load charts: ${state.error}'));
          }
          final charts = state.charts;
          if (charts == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (charts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  state.query.isEmpty
                      ? 'No charts yet.\nTap "New chart" to add one.'
                      : 'No chart matches "${state.query}".',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: charts.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) => _ChartTile(chart: charts[i]),
          );
        },
      ),
    );
  }
}

enum _Action { edit, duplicate, delete }

class _ChartTile extends StatelessWidget {
  const _ChartTile({required this.chart});
  final ChartEntry chart;

  @override
  Widget build(BuildContext context) {
    final c = chart;
    final initial = c.name.isEmpty ? '?' : c.name.characters.first.toUpperCase();
    return ListTile(
      leading: CircleAvatar(child: Text(initial)),
      title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${formatDate(c.year, c.month, c.day)} · '
        '${formatTime(c.hour, c.minute, c.second)} · ${c.place.name}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => context.push(Routes.chart(c.id!)),
      trailing: PopupMenuButton<_Action>(
        onSelected: (a) => _onAction(context, a),
        itemBuilder: (_) => const [
          PopupMenuItem(value: _Action.edit, child: Text('Edit')),
          PopupMenuItem(value: _Action.duplicate, child: Text('Duplicate')),
          PopupMenuItem(value: _Action.delete, child: Text('Delete')),
        ],
      ),
    );
  }

  Future<void> _onAction(BuildContext context, _Action a) async {
    final cubit = context.read<ChartListCubit>();
    switch (a) {
      case _Action.edit:
        await context.push(Routes.editChart(chart.id!));
      case _Action.duplicate:
        await cubit.duplicate(chart.id!);
      case _Action.delete:
        final ok = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete chart?'),
            content: Text('"${chart.name}" will be removed from this phone. '
                'This cannot be undone.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete')),
            ],
          ),
        );
        if (ok == true) await cubit.delete(chart.id!);
    }
  }
}
