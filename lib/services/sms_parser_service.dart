// ============================================================================
// lib/services/sms_parser_service.dart
// Universal Case-Insensitive SMS Parser for TCMU-1 & Future Starters
// ============================================================================

class TcmuSmsParserService {
  /// Parses the exact *TCMU-1 USERS* reply from 10* command:
  /// *TCMU-1 USERS*
  /// USER1 = 8081728811,
  /// USER2 = 7839455008,
  /// USER4 = 9236504217.
  static List<String> parseUsersReply(String rawSms) {
    final List<String> slots = ['', '', '', ''];
    for (int i = 1; i <= 4; i++) {
      final regex = RegExp(
        r'USER\s*' + i.toString() + r'\s*=\s*(\d{10,12})',
        caseSensitive: false,
      );
      final match = regex.firstMatch(rawSms);
      if (match != null) {
        slots[i - 1] = match.group(1) ?? '';
      }
    }
    return slots;
  }

  /// Case-insensitive substring matcher so 'manual start', 'MANUAL START',
  /// or 'Motor manual start' all trigger reliably.
  static bool matchesReplyPattern(String incomingSms, String configuredPattern) {
    if (configuredPattern.trim().isEmpty) return false;
    return incomingSms
        .toUpperCase()
        .contains(configuredPattern.trim().toUpperCase());
  }
}
