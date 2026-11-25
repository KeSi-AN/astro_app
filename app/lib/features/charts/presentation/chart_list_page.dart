import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
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
    _sub = _repo
        .watchAll(search: query)
        .listen(
          (c) => emit(ChartListState(query: query, charts: c)),
          onError: (Object e) => emit(ChartListState(query: query, error: e)),
        );
  }

  Future<int> duplicate(int id, String suffix) =>
      _repo.duplicate(id, suffix: suffix);
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
        title: Text(context.l10n.chartsTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.panchang,
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () => context.push(Routes.panchang),
          ),
          IconButton(
            tooltip: context.l10n.settings,
            icon: const Icon(Icons.tune),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: context.l10n.searchCharts,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: context.read<ChartListCubit>().search,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.newChart),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.newChart),
      ),
      body: BlocBuilder<ChartListCubit, ChartListState>(
        builder: (context, state) {
          if (state.error != null) {
            return Center(
              child: Text(context.l10n.loadChartsError('${state.error}')),
            );
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
                      ? context.l10n.noChartsYet
                      : context.l10n.noChartMatches(state.query),
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
    final initial = c.name.isEmpty
        ? '?'
        : c.name.characters.first.toUpperCase();
    return ListTile(
      leading: CircleAvatar(child: Text(initial)),
      title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${formatDate(c.year, c.month, c.day, month: context.terms.month)} · '
        '${formatTime(c.hour, c.minute, c.second)} · ${c.place.name}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => context.push(Routes.chart(c.id!)),
      trailing: PopupMenuButton<_Action>(
        onSelected: (a) => _onAction(context, a),
        itemBuilder: (_) => [
          PopupMenuItem(value: _Action.edit, child: Text(context.l10n.edit)),
          PopupMenuItem(
            value: _Action.duplicate,
            child: Text(context.l10n.duplicate),
          ),
          PopupMenuItem(
            value: _Action.delete,
            child: Text(context.l10n.delete),
          ),
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
        await cubit.duplicate(chart.id!, context.l10n.copySuffix);
      case _Action.delete:
        final ok = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.deleteChartTitle),
            content: Text(context.l10n.deleteChartBody(chart.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.l10n.delete),
              ),
            ],
          ),
        );
        if (ok == true) await cubit.delete(chart.id!);
    }
  }
}
