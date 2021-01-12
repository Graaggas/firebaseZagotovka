import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/screens/home_screen/tasks_page.dart';
import 'package:ultimate_task/screens/sign_in/sign_in_page.dart';
import 'package:ultimate_task/service/auth.dart';
import 'package:ultimate_task/service/database.dart';

class LandingPage extends StatelessWidget {
  static const routeName = '/landingPage';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        //* если подключился к данным
        if (snapshot.connectionState == ConnectionState.active) {
          //* получаем данные о пользователе
          final User user = snapshot.data;

          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: user.uid),
            child: TasksPage(),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
