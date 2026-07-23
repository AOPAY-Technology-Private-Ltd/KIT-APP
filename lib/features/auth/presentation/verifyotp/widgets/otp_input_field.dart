import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatelessWidget {

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;


  const OtpInputField({

    super.key,

    required this.controller,

    required this.focusNode,

    required this.onChanged,

  });



  @override
  Widget build(BuildContext context) {


    return TextField(

      controller: controller,

      focusNode: focusNode,


      keyboardType:
      TextInputType.number,


      textInputAction:
      TextInputAction.next,


      textAlign:
      TextAlign.center,


      textAlignVertical:
      TextAlignVertical.center,


      maxLength:1,


      cursorColor:
      Colors.black,


      autofillHints: const [

        AutofillHints.oneTimeCode,

      ],


      inputFormatters:[

        FilteringTextInputFormatter.digitsOnly,

      ],



      style: const TextStyle(

        fontSize:18,

        fontWeight:
        FontWeight.w600,

        color:
        Colors.black,

      ),



      decoration: InputDecoration(


        counterText:"",


        filled:true,


        fillColor:
        Colors.white,


        isDense:true,


        contentPadding:
        const EdgeInsets.symmetric(
          vertical:15,
        ),



        border:
        OutlineInputBorder(


          borderRadius:
          BorderRadius.circular(14),


          borderSide:
          BorderSide(

            color:
            Colors.black.withValues(
              alpha:.6,
            ),

          ),

        ),



        enabledBorder:
        OutlineInputBorder(


          borderRadius:
          BorderRadius.circular(14),


          borderSide:
          BorderSide(

            color:
            Colors.black.withValues(
              alpha:.6,
            ),

          ),

        ),




        focusedBorder:
        OutlineInputBorder(


          borderRadius:
          BorderRadius.circular(14),


          borderSide:
          const BorderSide(

            color:
            Colors.black,

            width:2,

          ),

        ),


      ),



      onChanged:
      onChanged,


    );

  }

}