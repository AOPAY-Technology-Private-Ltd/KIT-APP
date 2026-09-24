import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logkit/features/lockit/splash/presentation/pages/splash_page.dart';



void main() {

  testWidgets(
    'Splash page renders correctly',
        (WidgetTester tester) async {


      await tester.pumpWidget(

        const MaterialApp(

          home: SplashPage(),

        ),

      );


      await tester.pump();


      expect(
        find.byType(SplashPage),
        findsOneWidget,
      );


    },
  );

}