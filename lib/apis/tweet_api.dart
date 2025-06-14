import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../Constants/constants.dart';
import '../core/core.dart';
import '../models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetApi(db: ref.watch(appwriteDatabaseProvider), 
                  realtime: ref.watch(appwriteRealtimeProvider));
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
}

class TweetApi implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;
  TweetApi({
    required Databases db,
    required Realtime? realtime,
  }) : _db = db, _realtime = realtime ?? Realtime(Client());
  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
        
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'An error occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
  
  @override
  Future<List<Document>> getTweets() async {
   final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.orderDesc('tweetedAt'),
        Query.limit(100), // Adjust the limit as needed
      ],
    );
    return documents.documents;
  
  }
  
  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents'
    ]).stream;
  }
}
