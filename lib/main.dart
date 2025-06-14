import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mns_final/common/common.dart';
import 'package:mns_final/common/loading_page.dart';
import 'package:mns_final/features/auth/controller/auth_controller.dart';
import 'package:mns_final/features/auth/view/login_view.dart';
import 'package:mns_final/features/auth/view/signup_view.dart';
import 'package:mns_final/features/home/view/home_view.dart';
import 'package:mns_final/theme/theme.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Twitter Clone',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
      data: (user){
        
        if(user!=null){
          return HomeView();
        }
        return const SignupView();
      }, 
      error: (error,st)=> ErrorText(error: error.toString()), 
      loading: ()=> const LoadingPage()),
    );
  }
} 

