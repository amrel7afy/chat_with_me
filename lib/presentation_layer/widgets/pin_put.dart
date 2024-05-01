import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../constants/my_text_styles.dart';

class PinPutBuilder extends StatefulWidget {
  final String? otpCode;
   Function(String?)? onChange;
   Function(String?)? onSubmitted;
   Function(String?)? onCompleted;
   PinPutBuilder({super.key,required this.otpCode,this.onChange,this.onSubmitted,this.onCompleted});

  @override
  State<PinPutBuilder> createState() => _PinPutBuilderState();
}
const double submittedBorderRadius=14;
class _PinPutBuilderState extends State<PinPutBuilder> {
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final focusedBorderColor = const Color.fromRGBO(23, 171, 144, 1);
  final fillColor = const Color.fromRGBO(243, 246, 249, 0);
  final pinController = TextEditingController();


  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: MyTextStyles.pinPut,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(submittedBorderRadius),
      border: Border.all(color: const Color.fromRGBO(23, 171, 144, 0.4)),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 6,
      controller: pinController,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 8),
    /*  validator: (value) {
        return value == '2222' ? null : 'Pin is incorrect';
      },*/
      // onClipboardFound: (value) {
      //   debugPrint('onClipboardFound: $value');
      //   pinController.setText(value);
      // },
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: widget.onCompleted,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChange,

      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 22,
            height: 1,
            color: focusedBorderColor,
          ),
        ],
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: fillColor,
          borderRadius: BorderRadius.circular(submittedBorderRadius),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: Colors.redAccent),
      ),
    );
  }
}
