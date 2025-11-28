class ApiUrls {
  // Base API URLs
  static const String baseUrl = 'https://lxgau.com.au/wp-json/lxg/v1';
  static const String jwtBaseUrl = 'https://lxgau.com.au/wp-json/jwt-auth/v1';
  
  // API Endpoints
  static const String login = '$jwtBaseUrl/token';
  static const String me = '$baseUrl/me';
  static const String entries = '$baseUrl/entries';
  static const String memberStatus = '$baseUrl/member-status';
  static const String cancelMembership = '$baseUrl/cancel-subscription';
  
  // External Website URLs
  static const String membershipUpgrade = 'https://www.luxegiveaway.net.au/lxgau-membership';
  static const String cancelSubscription = 'https://lxgau.com.au/my-account/cancel-subscription/';
  
  // Giveaway URLs
  static const String mercedesBenzGiveaway = 'https://www.luxegiveaway.net.au/mercedez-benz-2019-gt63s-amg';
  static const String fortunerGiveaway = 'https://www.luxegiveaway.net.au/toyota-fortuner-crusade';
  
  // Affiliate Partner URLs
  static const String bloomingdales = 'https://click.linksynergy.com/fs-bin/click?id=9eEDaAIot0o&offerid=778020.857&type=3&subid=0';
  static const String designerWardrobe = 'https://click.linksynergy.com/fs-bin/click?id=9eEDaAIot0o&offerid=1770446.2&type=3&subid=0';
  static const String femmeConnection = 'https://click.linksynergy.com/fs-bin/click?id=9eEDaAIot0o&offerid=1770446.2&type=3&subid=0';
  static const String jdSports = 'https://click.linksynergy.com/fs-bin/click?id=9eEDaAIot0o&offerid=1224020.96&type=3&subid=0';
  static const String loccitane = 'https://click.linksynergy.com/fs-bin/click?id=9eEDaAIot0o&offerid=808811.923&type=3&subid=0';
  static const String lornaJane = 'https://click.linksynergy.com/fs-bin/click?id=9eEDaAIot0o&offerid=683598.135&subid=0&type=4';
  static const String onlineCoursesAu = 'https://click.linksynergy.com/fs-bin/click?id=9eEDaAIot0o&offerid=1345333.8&type=3&subid=0';
}