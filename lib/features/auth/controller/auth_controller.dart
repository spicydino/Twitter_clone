import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mns_final/apis/auth_api.dart';
import 'package:mns_final/core/utils.dart';
import 'package:mns_final/features/auth/view/login_view.dart';
import 'package:mns_final/features/home/view/home_view.dart';
import 'package:mns_final/models/user_model.dart';

import '../../../apis/user_api.dart';


final authControllerProvider = StateNotifierProvider<AuthController,bool>((ref) {
  return AuthController(
    authAPI: ref.watch(AuthApiProvider),
    userAPI: ref.watch(userAPIProvider),
  );

});

final CurrentUserDetailsProvider = FutureProvider((ref) {
  final CurrentUserID = ref.watch(currentUserAccountProvider).value!.$id;
  final UserDetail = ref.watch(UserDetailsProvider(CurrentUserID));
  return UserDetail.value;
});

final UserDetailsProvider = FutureProvider.family((ref,String uid)  {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});


final currentUserAccountProvider = FutureProvider((ref)  {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthApi authAPI, required UserAPI userAPI}) 
  : _authAPI = authAPI, _userAPI = userAPI, super(false);


  Future<User?> currentUser() => _authAPI.currentUserAccount();
  // Method to toggle the authentication state
  void signUp ({
    required String email,
    required String password,
    required BuildContext context,
  }) async{
    state = true; // Set loading state
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l)=> showSnackBar(context,l.message),
     (r) async{
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: r.$id,
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold((l) => showSnackBar(context, l.message), 
        (r) {
          showSnackBar(context, 'Account Created Successfully');
          Navigator.push(context, LoginView.route());
        });
        
      });
  }



  void login ({
    required String email,
    required String password,
    required BuildContext context,
  }) async{
    state = true; // Set loading state
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l)=> showSnackBar(context,l.message),
     (r){
      Navigator.push(context, HomeView.route());
     });
  }



  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document?.data ?? {});
    return updatedUser;
  }
}