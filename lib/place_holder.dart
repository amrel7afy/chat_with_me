/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class UserModel {
  final String name;
  final int age;

  UserModel({required this.name, required this.age});
  factory UserModel.init(){return UserModel(name: '',age: 1);}

  Map<String, dynamic> toJson() {
    return {'name': name, 'age': age};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(name: json['name'], age: json['age']);
  }
}

class UserService {
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> setUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson().toString());
    _user = user;
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userJson as Map));
    }
    return null;
  }

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    _user = null;
  }
}



// Authentication Cubit
class AuthCubit extends Cubit<bool> {
  AuthCubit() : super(false);

  void authenticateUser() {
    // Simulating user authentication (e.g., Firebase auth)
    // Once authenticated, emit true
    Future.delayed(Duration(seconds: 2), () {
      emit(true);
    });
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => AuthCubit(),
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase & Cubit Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final userService = getIt<UserService>();
                await userService.setUser(UserModel(name: 'John Doe', age: 30));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User set: John Doe')),
                );
              },
              child: Text('Set User'),
            ),
            ElevatedButton(
              onPressed: () async {
                final userService = getIt<UserService>();
                final user = await userService.getUser();

                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User retrieved: ${user.name}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User not found')),
                  );
                }
              },
              child: Text('Get User'),
            ),
            ElevatedButton(
              onPressed: () async {
                final userService = getIt<UserService>();
                await userService.removeUser();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User removed')),
                );
              },
              child: Text('Remove User'),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).authenticateUser();
              },
              child: Text('Authenticate User'),
            ),
          ],
        ),
      ),
    );
  }
}*/
