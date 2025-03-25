import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/screens/create_capsule/create_capsule_screen.dart';
import 'package:future_capsule/screens/my_capsules/my_capusles_screen.dart';
import 'package:future_capsule/screens/my_futures/my_future_capusles.dart';
import 'package:future_capsule/screens/my_sent_capsules/my_sent_capsule_screen.dart';
import 'package:future_capsule/screens/profile/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,

      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: false,
      resizeToAvoidBottomInset: true,
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      backgroundColor: AppColors.dNavigationBackground,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: false,
      navBarStyle: NavBarStyle.style15,
      navBarHeight: MediaQuery.sizeOf(context).height * 0.075,
    );
  }

  List<Widget> _buildScreens() {
    return const [
      // MySentCapsuleDetails(),
      MySentCapuslesScreen(),

      MyFutureCapsules(),
      CreateCapsuleScreen(),
      MyCapuslesScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        activeColorPrimary: AppColors.dActiveColorPrimary,
        inactiveColorPrimary: AppColors.dInActiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon:
            const Icon(CupertinoIcons.rectangle_fill_on_rectangle_angled_fill),
        title: ("Future"),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        activeColorPrimary: AppColors.dActiveColorPrimary,
        inactiveColorPrimary: AppColors.dInActiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        contentPadding: 12,
        icon: const Icon(
          CupertinoIcons.create,
          size: 30,
          color: Color.fromRGBO(32, 32, 32, 1),
        ),
        title: ("Create"),
        iconSize: 48,
        textStyle: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 12, color: Colors.white),
        activeColorPrimary: AppColors.dActiveColorPrimary,
        activeColorSecondary: AppColors.dActiveColorSecondary,
        inactiveColorPrimary: AppColors.dInActiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          CupertinoIcons.macwindow,
        ),
        title: ("My capusles"),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        activeColorPrimary: AppColors.dActiveColorPrimary,
        inactiveColorPrimary: AppColors.dInActiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        title: ("Settings"),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        activeColorPrimary: AppColors.dActiveColorPrimary,
        inactiveColorPrimary: AppColors.dInActiveColorPrimary,
      ),
    ];
  }
}
