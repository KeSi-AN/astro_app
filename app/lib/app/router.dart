import 'package:go_router/go_router.dart';

import '../features/charts/presentation/chart_form_page.dart';
import '../features/appointments/presentation/appointment_form_page.dart';
import '../features/backup/backup_page.dart';
import '../features/chart_view/presentation/chart_view_page.dart';
import '../features/clients/presentation/client_detail_page.dart';
import '../features/clients/presentation/client_form_page.dart';
import '../features/home/home_page.dart';
import '../features/matching/matching_page.dart';
import '../features/panchang/panchang_page.dart';
import '../features/report/letterhead_page.dart';
import '../features/settings/settings_page.dart';

abstract final class Routes {
  static const charts = '/';
  static const newChart = '/chart/new';
  static const settings = '/settings';
  static const letterhead = '/settings/letterhead';
  static const panchang = '/panchang';
  static const matching = '/matching';
  static const backup = '/settings/backup';
  static const newClient = '/clients/new';
  static String client(int id) => '/clients/$id';
  static String editClient(int id) => '/clients/$id/edit';
  static String newAppointment({int? clientId}) =>
      clientId == null ? '/appointments/new' : '/appointments/new?client=$clientId';
  static String appointment(int id) => '/appointments/$id';

  /// New chart linked to a client as [relation] (a Relation name).
  static String newChartFor(int clientId, String relation) =>
      '/chart/new?client=$clientId&relation=$relation';
  static String chart(int id) => '/chart/$id';
  static String editChart(int id) => '/chart/$id/edit';
}

GoRouter buildRouter() => GoRouter(
  routes: [
    GoRoute(
      path: Routes.charts,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'matching',
          builder: (context, state) => const MatchingPage(),
        ),
        GoRoute(
          path: 'panchang',
          builder: (context, state) => const PanchangPage(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsPage(),
          routes: [
            GoRoute(
              path: 'letterhead',
              builder: (context, state) => const LetterheadPage(),
            ),
            GoRoute(
              path: 'backup',
              builder: (context, state) => const BackupPage(),
            ),
          ],
        ),
        GoRoute(
          path: 'chart/new',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            return ChartFormPage(
              clientId: int.tryParse(q['client'] ?? ''),
              relation: q['relation'],
            );
          },
        ),
        GoRoute(
          path: 'clients/new',
          builder: (context, state) => const ClientFormPage(),
        ),
        GoRoute(
          path: 'clients/:id',
          builder: (context, state) =>
              ClientDetailPage(id: int.parse(state.pathParameters['id']!)),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) =>
                  ClientFormPage(id: int.parse(state.pathParameters['id']!)),
            ),
          ],
        ),
        GoRoute(
          path: 'appointments/new',
          builder: (context, state) => AppointmentFormPage(
            clientId: int.tryParse(state.uri.queryParameters['client'] ?? ''),
          ),
        ),
        GoRoute(
          path: 'appointments/:id',
          builder: (context, state) =>
              AppointmentFormPage(id: int.parse(state.pathParameters['id']!)),
        ),
        GoRoute(
          path: 'chart/:id',
          builder: (context, state) =>
              ChartViewPage(id: int.parse(state.pathParameters['id']!)),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) =>
                  ChartFormPage(id: int.parse(state.pathParameters['id']!)),
            ),
          ],
        ),
      ],
    ),
  ],
);
