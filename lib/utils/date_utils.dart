/// Date Utility Functions
/// Provides consistent date normalization across the app
///
/// IMPORTANT: All date comparisons in the app should use these utilities
/// to ensure consistency between database queries and model calculations.

/// Normalize a DateTime to midnight (00:00:00) of the same day
///
/// This removes the time component, making date comparisons accurate.
/// Example:
///   Input:  2025-01-18 15:30:45
///   Output: 2025-01-18 00:00:00
DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Get today's date normalized to midnight
DateTime getToday() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// Calculate days between two dates (normalized)
///
/// Returns the number of full days between two dates.
/// Both dates are normalized to midnight before comparison.
int daysBetween(DateTime start, DateTime end) {
  final normalizedStart = normalizeDate(start);
  final normalizedEnd = normalizeDate(end);
  return normalizedEnd.difference(normalizedStart).inDays;
}

/// Check if a date is in the past (before today)
bool isPastDate(DateTime date) {
  final today = getToday();
  final normalizedDate = normalizeDate(date);
  return normalizedDate.isBefore(today);
}

/// Check if a date is in the future (after today)
bool isFutureDate(DateTime date) {
  final today = getToday();
  final normalizedDate = normalizeDate(date);
  return normalizedDate.isAfter(today);
}

/// Check if a date is today
bool isToday(DateTime date) {
  final today = getToday();
  final normalizedDate = normalizeDate(date);
  return normalizedDate.isAtSameMomentAs(today);
}

/// Get a date range for querying products expiring within N days
///
/// Returns a tuple of (startDate, endDate) normalized to midnight.
/// Used for database queries to get expiring soon products.
///
/// Example for days=7:
///   today = 2025-01-18 00:00:00
///   returns: (2025-01-18 00:00:00, 2025-01-26 00:00:00)
///   Query: WHERE expiry_date >= start AND expiry_date < end
(DateTime start, DateTime end) getExpiryDateRange(int days) {
  final today = getToday();
  final futureDate = today.add(Duration(days: days + 1)); // +1 to include Nth day
  return (today, futureDate);
}
