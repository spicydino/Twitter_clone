class AppwriteConstants {
  static const String databaseId = '683ff81000067760044a';
  static const String projectId = '683ff3db000640a6ff30';
  static const String endPoint = 'http://192.168.0.101/v1';
  static const String usersCollection = '6843db3d0038f597b8ca';
  static const String tweetsCollection = '68459f080037a8185d30';//68459f080037a8185d30
  // static const String notificationsCollection = '63cd5ff88b08e40a11bc';

  static const String imagesBucket = '684803fa00299a13e3fa';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}

//683ff81000067760044a
//6843db3d0038f597b8ca user collection