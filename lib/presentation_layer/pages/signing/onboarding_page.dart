

import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/business_logic_layer/login_cubit/login_states.dart';
import 'package:chat_with_me/constants/strings.dart';
import 'package:chat_with_me/data_layer/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/methods.dart';
import '../../../constants/my_colors.dart';
import '../../../constants/my_text_styles.dart';
import '../../widgets/custom_button.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: getHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: getHeight(context) * 0.6,
                  child: Image.asset(
                    'assets/gif/message.gif',
                  )),
              const Spacer(
                flex: 4,
              ),
              const Text(
                'Let\'s get Started',
                style: MyTextStyles.headLine1,
              ),
              const Spacer(
                flex: 1,
              ),
              const Text(
                'Never a better time than now to start',
                style: MyTextStyles.headLine4,
              ),
              const Spacer(
                flex: 1,
              ),
              BlocBuilder<LoginCubit,LoginStates>(
                builder: (context,state) {

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButton(
                        text: 'Message your contacts',
                        onPressed: () {
                         Navigator.pushNamed(context, logInPage);
                         CacheHelper.saveData(key: isOnBoardingKey, value: true);
                        },textStyle: MyTextStyles.headLine2.copyWith(color: Colors.white), backGroundColor: MyColors.kPrimaryColor
                      ),
                    ),
                  );
                }
              ),
              const Spacer(
                flex: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
