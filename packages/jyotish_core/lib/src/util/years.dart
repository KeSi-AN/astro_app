/// Years → years/months/days the way Indian kundlis print dasha balances:
/// 12 months of 30 days per year (so the printed parts add up evenly).
(int years, int months, int days) yearsToYmd(double years) {
  var totalDays = (years * 360).round();
  final y = totalDays ~/ 360;
  totalDays %= 360;
  return (y, totalDays ~/ 30, totalDays % 30);
}

String formatYmd(double years) {
  final (y, m, d) = yearsToYmd(years);
  return '${y}y ${m}m ${d}d';
}
