import 'dart:developer';

import 'package:chat_with_me/business_logic_layer/bloc_observer.dart';
import 'package:chat_with_me/business_logic_layer/chat_cubit/chat_cubit.dart';
import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/presentation_layer/pages/messaging_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'AppRouter.dart';
import 'constants/my_colors.dart';
import 'constants/theme.dart';
import 'data_layer/cache_helper.dart';
import 'firebase_options.dart';
import 'locator.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaEnterpriseProvider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.debug
    );
  } catch (e) {
    log('Error initializing Firebase: $e');
  }
  //String initialRoute=placeholder;
  String initialRoute =
      await AppRouter().getInitialRouteFromSharedPreferences();
  log(initialRoute);
  setupLocator();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: MyColors.kGifBackGroundColor));

  runApp(ChatApp(
    initialRoute: initialRoute,
  ));
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ChatCubit()

        ),
        BlocProvider(
            create: (BuildContext context) =>
                LoginCubit()..getTheUserEitherFromFireStoreORCache(),
            lazy: false),
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        initialRoute: initialRoute,
        debugShowCheckedModeBanner: false,
        theme: themeData,
        onGenerateRoute: AppRouter().generateRoute,
      ),
    );
  }
}
