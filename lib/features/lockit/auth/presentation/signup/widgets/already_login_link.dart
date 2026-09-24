import 'package:flutter/material.dart';


class AlreadyLoginLink extends StatelessWidget {


  final VoidCallback onTap;



  const AlreadyLoginLink({

    super.key,

    required this.onTap,

  });





  @override
  Widget build(BuildContext context) {


    final theme = Theme.of(context);


    final colorScheme = theme.colorScheme;



    return GestureDetector(


      onTap: onTap,



      child: Text.rich(


        TextSpan(


          children: [



            TextSpan(


              text: "Already have register?",


              style: theme.textTheme.bodyMedium?.copyWith(


                fontSize: 14,


                fontWeight: FontWeight.w400,


                color: Colors.black,


              ),


            ),





            const TextSpan(

              text: " ",

            ),





            TextSpan(


              text: "Login →",


              style: theme.textTheme.bodyMedium?.copyWith(


                fontSize: 14,


                fontWeight: FontWeight.w500,


                color: colorScheme.primary,


              ),


            ),



          ],


        ),


        textAlign: TextAlign.center,


      ),


    );


  }


}