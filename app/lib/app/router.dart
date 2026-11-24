import 'package:go_router/go_router.dart';

import '../features/charts/presentation/chart_form_page.dart';
import '../features/charts/presentation/chart_list_page.dart';
import '../features/charts/presentation/chart_view_page.dart';

abstract final class Routes {
  static const charts = '/';
  static const newChart = '/chart/new';
  static String chart(int id) => '/chart/$id';
  static String editChart(int id) => '/chart/$id/edit';
}

GoRouter buildRouter() => GoRouter(
      routes: [
        GoRoute(
          path: Routes.charts,
          builder: (context, state) => const ChartListPage(),
          routes: [
            GoRoute(
              path: 'chart/new',
              builder: (context, state) => const ChartFormPage(),
            ),
            GoRoute(
              path: 'chart/:id',
              builder: (context, state) =>
                  ChartViewPage(id: int.parse(state.pathParameters['id']!)),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => ChartFormPage(
                      id: int.parse(state.pathParameters['id']!)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
