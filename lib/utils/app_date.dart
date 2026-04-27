class AppDate {
  const AppDate._();

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime today() {
    return startOfDay(DateTime.now());
  }

  static String dayKey(DateTime date) {
    final d = startOfDay(date);
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static DateTime parseDayKey(String key) {
    final parts = key.split('-');
    if (parts.length != 3) {
      return today();
    }

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) {
      return today();
    }

    return DateTime(year, month, day);
  }
}