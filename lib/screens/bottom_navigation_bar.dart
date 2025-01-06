import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/screens/create_capsule/create_capsule_screen.dart';
import 'package:future_capsule/screens/home/home_screen.dart';
import 'package:future_capsule/screens/profile/profile_screen.dart';
import 'package:future_capsule/screens/test.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      // popBehaviorOnSelectedNavBarItemPress: ,r
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: false, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
   
      padding: const EdgeInsets.only(top: 12,bottom: 12),
      backgroundColor: Colors.red,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarStyle: NavBarStyle.style15,
      navBarHeight: 68,
    );
  }

  List<Widget> _buildScreens() {
    return const [
      HomeScreen(),
        Text("My Capsule"),
      CreateCapsuleScreen(),
      Text("My Capsule"),
      ProfileScreen(),

    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
        scrollController: _scrollController,
       
      ),
      
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.rectangle_fill_on_rectangle_angled_fill),
        title: ("Future"),

        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
        scrollController: _scrollController,
      
      ),
     
      PersistentBottomNavBarItem(
        contentPadding: 12,
         
        icon: const Icon(CupertinoIcons.create,size: 34,),
        title: ("Create"),
        iconSize: 348,
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.red,
        inactiveColorPrimary: Colors.white70,

        scrollController: _scrollController,
        
      ),


      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.macwindow),
        title: ("Settings"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
        scrollController: _scrollController,
        
       
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("Settings"),
      activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
        scrollController: _scrollController,
       
      ),
    ];
  }
}
