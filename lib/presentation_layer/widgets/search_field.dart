import 'package:flutter/material.dart';

 Widget defaultFormField({required String hint,
  required IconData prefixIcon,
  required TextInputType textInputType,
   String? Function(String?)? validate,
  bool obscureText=false,
   IconData? suffixIcon,

  VoidCallback? suffixPressed
})=>TextFormField(
   keyboardType: textInputType,
   validator: validate,
   obscureText: obscureText,
   decoration: InputDecoration(
       hintText: hint,
       suffixIcon: IconButton(
         onPressed: suffixPressed,
         icon: Icon(
             suffixIcon
         ),
       ),
       prefixIcon: Icon(
         prefixIcon,
         // color: primaryColor,
       ),
       enabledBorder: const UnderlineInputBorder(
           borderSide:
           BorderSide(
             // color: primaryColor
           ))),
 );

class DefaultFormField extends StatelessWidget {

   String? hint;
  late IconData prefixIcon;
  late TextInputType textInputType;
  String? Function(String?)? validate;
  bool obscureText=false;
  IconData? suffixIcon;
  VoidCallback? suffixPressed;
    Function(String?)? onSubmitted;
  Widget?label;
   DefaultFormField({
    super.key,
     this.hint,
     this.label,
     this.suffixPressed,
    required this.prefixIcon,this.onSubmitted,required this.textInputType,this.validate,this.suffixIcon,required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmitted,
      keyboardType: textInputType,
      validator: validate,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: label,
          hintText: hint,
          suffixIcon: IconButton(
            onPressed: suffixPressed,
            icon: Icon(
                suffixIcon
            ),
          ),
          prefixIcon: Icon(
            prefixIcon,
            // color: primaryColor,
          ),
          border: const OutlineInputBorder(),
          ),
    );
  }


}