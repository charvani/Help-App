import 'package:flutter/material.dart';
import 'package:help_app_flutter/commons/colors.dart';
import 'package:help_app_flutter/commons/constants.dart';
import 'package:help_app_flutter/screens/main_screens/enquiry_screen/enquiry_screen.dart';
import 'package:help_app_flutter/screens/main_screens/home_screens/home_screen.dart';
import 'package:help_app_flutter/screens/main_screens/myaccount_screens/myaccount_screen.dart';
import 'package:help_app_flutter/screens/main_screens/myposts_screen/myposts_screen.dart';

import '../../../commons/common_functions.dart';
import '../addpost_screen/addpost_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomBarScreen extends StatefulWidget {
  final int index;
  const BottomBarScreen({super.key, required this.index});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const EnquiryScreen(),
    const AddPostScreen(),
    const MyPostsScreen(),
    const MyAccountScreen()
  ];
  @override
  void initState() {
    setState(() {
      selectedIndex = widget.index;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Center(child: _widgetOptions.elementAt(selectedIndex)),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          child: BottomNavigationBar(
            selectedLabelStyle:
                TextStyle(fontSize: fontSize10, fontFamily: "Poppins SemiBold"),
            unselectedLabelStyle:
                TextStyle(fontSize: fontSize8, fontFamily: "Poppins"),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.home,
                ),
                label: "Home".tr(),
              ),
              BottomNavigationBarItem(
                icon: Image.asset("assets/images/enquiry.png",
                    color: (selectedIndex == 1)
                        ? orangeColor
                        : blackColor.withOpacity(0.4),
                    height: 19,
                    alignment: Alignment.bottomCenter),
                label: "Enquiry".tr(),
              ),
              BottomNavigationBarItem(
                  icon: CircleAvatar(
                      backgroundColor: appThemeColor,
                      radius: 23,
                      child: Icon(
                        Icons.add,
                        size: 28,
                        color: whiteColor,
                      )),
                  label: ''),
              BottomNavigationBarItem(
                icon: Image.asset("assets/images/My Posts-menu.png",
                    color: (selectedIndex == 3)
                        ? orangeColor
                        : blackColor.withOpacity(0.4),
                    height: 19,
                    alignment: Alignment.bottomCenter),
                label: "My Posts".tr(),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/person.png",
                  height: 19,
                  alignment: Alignment.bottomCenter,
                  color: (selectedIndex == 4)
                      ? orangeColor
                      : blackColor.withOpacity(0.4),
                ),
                label: "My Account".tr(),
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: orangeColor,
            unselectedItemColor: blackColor.withOpacity(0.4),
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
