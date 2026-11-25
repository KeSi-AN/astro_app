import 'package:equatable/equatable.dart';

import '../../charts/domain/chart_entry.dart';

/// Someone who consults the astrologer.
class Client extends Equatable {
  const Client({
    this.id,
    required this.name,
    this.phone = '',
    this.city = '',
    this.notes = '',
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final String phone;
  final String city;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, name, phone, city, notes];
}

/// A row of the client list.
class ClientSummary {
  const ClientSummary({
    required this.client,
    required this.charts,
    this.nextAppointment,
    this.unpaid = 0,
  });

  final Client client;
  final int charts;
  final DateTime? nextAppointment;

  /// Sum of fees not yet paid.
  final double unpaid;
}

/// Who a linked chart is to the client.
enum Relation { self, spouse, son, daughter, father, mother, brother, sister, other }

/// A chart in a client's family, with the relation.
class FamilyChart {
  const FamilyChart(this.chart, this.relation);
  final ChartEntry chart;
  final Relation relation;
}

/// A PDF kundli shared or printed for one of the client's charts.
class ReportSent {
  const ReportSent({
    required this.chartId,
    required this.chartName,
    required this.at,
    required this.kind,
    required this.language,
    required this.pages,
  });

  final int chartId;
  final String chartName;
  final DateTime at;

  /// share | print
  final String kind;
  final String language;
  final int pages;
}
