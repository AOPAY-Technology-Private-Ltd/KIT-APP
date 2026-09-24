import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupTextField extends StatelessWidget {

  final String label;

  final String hint;

  final bool requiredField;

  final TextEditingController controller;

  final VoidCallback? onTap;

  final bool readOnly;

  final TextInputType keyboardType;

  final String? Function(String?)? validator;

  final void Function(String)? onChanged;

  final List<TextInputFormatter>? inputFormatters;



  const SignupTextField({

    super.key,

    required this.label,

    required this.hint,

    required this.controller,

    this.requiredField = false,

    this.onTap,

    this.readOnly = false,

    this.keyboardType = TextInputType.text,

    this.validator,

    this.onChanged,

    this.inputFormatters,

  });



  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity,


      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,


        children: [


          RichText(

            text: TextSpan(

              text: label,


              style: const TextStyle(

                color: Colors.black,

                fontSize: 10,

                fontFamily: 'Inter',

                fontWeight: FontWeight.w400,

              ),


              children: [


                if(requiredField)

                  const TextSpan(

                    text: " *",


                    style: TextStyle(

                      color: Color(0xffDC2626),

                    ),

                  ),


              ],

            ),

          ),



          const SizedBox(

            height: 6,

          ),



          TextFormField(

            controller: controller,


            keyboardType: keyboardType,


            readOnly: readOnly,


            onTap: onTap,


            validator: validator,


            onChanged: onChanged,


            inputFormatters: inputFormatters,



            style: const TextStyle(

              color: Colors.black,

              fontSize: 12,

              fontFamily: 'Inter',

              fontWeight: FontWeight.w400,

            ),



            decoration: InputDecoration(


              hintText: hint,


              hintStyle: TextStyle(

                color: Colors.black.withOpacity(0.50),

                fontSize: 12,

                fontFamily: 'Inter',

                fontWeight: FontWeight.w300,

              ),



              contentPadding: const EdgeInsets.symmetric(

                horizontal: 20,

                vertical: 14,

              ),



              enabledBorder: OutlineInputBorder(

                borderRadius: BorderRadius.circular(14),


                borderSide: BorderSide(

                  color: Colors.black.withOpacity(0.60),

                  width: 1,

                ),

              ),



              focusedBorder: OutlineInputBorder(

                borderRadius: BorderRadius.circular(14),


                borderSide: const BorderSide(

                  color: Colors.black,

                  width: 1,

                ),

              ),



              errorBorder: OutlineInputBorder(

                borderRadius: BorderRadius.circular(14),


                borderSide: const BorderSide(

                  color: Color(0xffDC2626),

                  width: 1,

                ),

              ),



              focusedErrorBorder: OutlineInputBorder(

                borderRadius: BorderRadius.circular(14),


                borderSide: const BorderSide(

                  color: Color(0xffDC2626),

                  width: 1,

                ),

              ),



              errorStyle: const TextStyle(

                color: Color(0xffDC2626),

                fontSize: 10,

                fontFamily: 'Inter',

                fontWeight: FontWeight.w400,

              ),


            ),

          ),

        ],

      ),

    );

  }

}