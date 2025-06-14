import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mns_final/models/user_model.dart';
import '../Constants/constants.dart';
import '../core/core.dart';


final userAPIProvider = Provider((ref) {
  return UserAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IUserAPI {
  FutureEither saveUserData(UserModel userModel);
  Future<Document?> getUserData(String uid);
}
  
class UserAPI implements IUserAPI{
  final Databases _db;
  UserAPI({
    required Databases db,
  }) : _db = db;

  @override
  FutureEither saveUserData(UserModel userModel) async {
    try{
     await  _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e,st) {
      return left(Failure(e.message ?? 'An error occurred', st));
    } catch (e,st) {
      return left(Failure(e.toString(), st));
    }
  }
  
  @override
  Future<Document?> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: uid,
    );
  }

}