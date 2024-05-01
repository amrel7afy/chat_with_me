import 'dart:developer';


import 'package:chat_with_me/business_logic_layer/check_contact_cubit/check_contacts_cubit.dart';
import 'package:chat_with_me/business_logic_layer/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:chat_with_me/business_logic_layer/list_chats_cubit/get_chats_cubit.dart';
import 'package:chat_with_me/business_logic_layer/listen_to_messages_cubit/listen_to_messages_cubit.dart';
import 'package:chat_with_me/data_layer/cache_helper.dart';
import 'package:chat_with_me/data_layer/models/user_model.dart';
import 'package:chat_with_me/presentation_layer/pages/all_chats_page.dart';
import 'package:chat_with_me/presentation_layer/pages/contacts_page.dart';
import 'package:chat_with_me/presentation_layer/pages/edit_profile_page.dart';
import 'package:chat_with_me/presentation_layer/pages/information_page.dart';
import 'package:chat_with_me/presentation_layer/pages/messaging_page.dart';
import 'package:chat_with_me/presentation_layer/pages/place_holder.dart';
import 'package:chat_with_me/presentation_layer/pages/signing/login_page.dart';
import 'package:chat_with_me/presentation_layer/pages/signing/onboarding_page.dart';
import 'package:chat_with_me/presentation_layer/pages/signing/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic_layer/add_reciever_chat_data_cubit/add_reciever_chat_data_cubit.dart';
import 'constants/strings.dart';

class AppRouter {

  Future<String> getInitialRouteFromSharedPreferences() async {
    bool isSignedIn = await CacheHelper.getData(key: isSignedInKey) ?? false;
    log('$isSignedIn isSignedIn');
    bool isOnBoarded = await CacheHelper.getData(key: isOnBoardingKey) ?? false;
    log('$isOnBoarded isOnBoarded');
    if (isSignedIn) {
      return allChatsPage; // User is logged in, navigate to chatPage
    } else if (isOnBoarded) {
      return logInPage; // User hasn't logged in but completed onboarding
    } else {
      return onBoardingPage; // User hasn't completed onboarding
    }
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onBoardingPage:
        return MaterialPageRoute(builder: (context) => const OnBoardingPage());
      case otpPage:
        final String verificationId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) =>
                OTpPage(verificationId: verificationId));
      case logInPage:
        return MaterialPageRoute(
          builder: (context) =>  const LoginPage(),
        );

      case contactsPage:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context)=>CheckContactsCubit(),
              child: const ContactsPage()),
        );
      case informationPage:
        return MaterialPageRoute(
          builder: (context) => const InformationPage(),
        );
      case messagingPage:
        final friendModel = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (context) =>
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AddRecieverChatDataCubit(),
                ), BlocProvider(
                  create: (context) => ListenToMessagesCubit(),
                ),
              ],child: MessagingPage(friendModel: friendModel)
            ));
      case allChatsPage:
        return MaterialPageRoute(builder: (context) =>
            BlocProvider(
              create: (context) => GetChatsCubit(),
              child: const AllChatsPage(),
            ));

      case editProfilePage:

        return MaterialPageRoute(builder: (context) =>
            BlocProvider(
              create: (context) => EditProfileCubit(),
              child: EditProfilePage(),
            ));
      case placeholder:
        return MaterialPageRoute(builder: (context) =>
            const PlaceHolder());
    }
    return null;
  }
}
