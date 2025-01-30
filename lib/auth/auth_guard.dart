import 'package:flutter/material.dart';
import 'package:trokot_dealer_mobile/auth/login_screen.dart';
import 'package:trokot_dealer_mobile/services/user.dart';

class AuthGuard extends StatelessWidget {
  final User? user;
  final Stream<User?> userStream;
  final Widget child;

  const AuthGuard({
    super.key,
    required this.user,
    required this.userStream,
    required this.child,    
  });

  @override
  Widget build(BuildContext context) {
    // print('+++ build()... user: $user');

    return StreamBuilder(
      stream: userStream,
      initialData: user,
      builder: (context, snapshot) {
        final currentUser = snapshot.data;
        // print('+++ build.StreamBuilder()... currentUser: $currentUser');

        if (currentUser == null) {
          return const LoginScreen();
        } else {
          return child;
        }
      },
    );
  }
}
