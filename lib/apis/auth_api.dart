import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' ; // for `User`
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../core/core.dart';
import '../core/provider.dart'; // Your own file where `FutureEither` and `Failure` are defined

// Type alias for better readability if not already defined
// typedef FutureEither<T> = Future<Either<Failure, T>>;

final AuthApiProvider = Provider((ref){
  final account = ref.watch(appwriteAccountProvider);
  return AuthApi(account: account);
});
 

abstract class IAuthApi {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });

  FutureEither<Session> login({
    required String email,
    required String password,
  });

  Future<User?> currentUserAccount();
}

class AuthApi implements IAuthApi {
  final Account _account;
  AuthApi({required Account account}) : _account = account;

   @override
  Future<User?> currentUserAccount() async {
    try {
      return await _account.get();
      
    } on AppwriteException {
      return null;
    } catch (e) {
     return null;
    }
  }
  

 


  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(user);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? 'An error occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
  
  @override
  FutureEither<Session> login({required String email, required String password}) 
    async {
    try {
      final session = await _account.createEmailPasswordSession(
        // userId: ID.unique(),   //we cant pass ID in emailpasswordsessionn but we can pass the name 
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? 'An error occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
  
 
  
}
