import 'package:flutter/material.dart';

import '../../../customer_list/presentation/pages/customer_list_view.dart';
import 'home_page.dart';
import '../widgets/home_header.dart';


class MainScreen extends StatefulWidget {

  const MainScreen({
    super.key,
  });


  @override
  State<MainScreen> createState() => _MainScreenState();

}



class _MainScreenState extends State<MainScreen> {


  int _currentIndex = 0;



  final List<Widget> _pages = const [

    HomePage(),

    CustomerListView(),

    HomePage(),

    HomePage(),

  ];





  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;


    final double bottomHeight = size.height * 0.085;


    return Scaffold(



      backgroundColor: const Color(0xFFF7F9FC),


      body: IndexedStack(

        index: _currentIndex,

        children: _pages,

      ),





      bottomNavigationBar: Container(


        height: bottomHeight + 18,



        decoration: BoxDecoration(


          color: Colors.white,



          borderRadius: const BorderRadius.only(

            topLeft: Radius.circular(20),

            topRight: Radius.circular(20),

          ),



          boxShadow: [


            BoxShadow(

              color: Colors.black.withOpacity(0.16),

              blurRadius: 8,

              offset: const Offset(0, -1),

            ),

          ],


        ),





        child: Stack(


          clipBehavior: Clip.none,


          alignment: Alignment.center,



          children: [




            Positioned(

              left: 0,

              right: 0,

              bottom: 0,



              child: SafeArea(


                child: SizedBox(


                  height: bottomHeight,


                  child: Align(


                    alignment: Alignment.center,


                    child: BottomNavigationBar(



                      currentIndex: _currentIndex,




                      onTap: (index){



                        if(index == 2){

                          return;

                        }



                        setState(() {


                          _currentIndex =
                          index > 2
                              ? index - 1
                              : index;


                        });


                      },




                      type: BottomNavigationBarType.fixed,



                      backgroundColor: Colors.transparent,



                      elevation: 0,




                      selectedItemColor:
                      const Color(0xFF2563EB),




                      unselectedItemColor:
                      Colors.black54,




                      selectedFontSize: 9,

                      unselectedFontSize: 9,



                      iconSize: 24,



                      items: const [




                        BottomNavigationBarItem(

                          icon: Icon(
                            Icons.home_outlined,
                          ),

                          label: "Home",

                        ),





                        BottomNavigationBarItem(

                          icon: Icon(
                            Icons.group_outlined,
                          ),

                          label: "Customer",

                        ),


                        BottomNavigationBarItem(

                          icon: SizedBox(

                            height: 35,

                          ),

                          label: "",

                        ),






                        BottomNavigationBarItem(

                          icon: Icon(
                            Icons.history_outlined,
                          ),

                          label: "History",

                        ),






                        BottomNavigationBarItem(

                          icon: Icon(
                            Icons.person_outline,
                          ),

                          label: "Profile",

                        ),



                      ],


                    ),


                  ),


                ),


              ),


            ),






            Positioned(


              top: -18,


              left: (size.width / 2) - 23,



              child: Container(


                width: 46,

                height: 46,



                decoration: ShapeDecoration(



                  color: const Color(0xFF2563EB),



                  shape: RoundedRectangleBorder(



                    side: const BorderSide(


                      width: 3,


                      strokeAlign:
                      BorderSide.strokeAlignOutside,


                      color: Color(0xFF2563EB),


                    ),




                    borderRadius:
                    BorderRadius.circular(40),



                  ),



                  shadows: [



                    BoxShadow(


                      color:
                      Colors.black.withOpacity(0.15),


                      blurRadius: 8,


                      offset:
                      const Offset(0,3),


                    ),


                  ],



                ),




                child: const Center(



                  child: Icon(



                    Icons.add,



                    color: Colors.white,



                    size: 26,



                  ),


                ),


              ),


            ),



          ],


        ),


      ),


    );


  }


}