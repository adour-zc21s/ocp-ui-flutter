class ApiConfig {
  // Ganti IP sesuai dengan target running Flutter Anda:
  // - Chrome / Web / Desktop : http://localhost:8081
  // - Emulator Android        : http://10.0.2.2:8081
  // - HP Fisik               : http://192.168.x.x:8081 (IP Komputer)
  static const String baseUrl = 'http://202.51.103.154:3004/api/v1';
  // static const String baseUrl = 'http://localhost:8081/api/v1';

  // Endpoint Auth
  static const String login = '$baseUrl/auth/authenticate';
  static const String register = '$baseUrl/auth/register';

  // Endpoint Tickets
  static const String tickets = '$baseUrl/tickets';
  static const String devices = '$baseUrl/dev';
  static const String brances = '$baseUrl/branches';
  static const String cariBranches = '$baseUrl/branches/search';
  static const String items = '$baseUrl/items';
  static const String monitoring = '$baseUrl/monitoring';
  static const String ticketAccounts = '$baseUrl/tickets/accounts';

  // Method pembantu untuk URL spesifik ID (contoh: /tickets/123)
  static String ticketDetail(String id) => '$tickets/$id';
  static String branchDetailStatus(dynamic id) => '$brances/$id/status';
  static String monitoringDetailStatus(dynamic id) => '$monitoring/$id/status';
  static String itemDetail(String id) => '$items/$id';

}
