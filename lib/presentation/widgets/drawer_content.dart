import 'package:flutter/material.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

class DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:ColorsPalette.primaryColor,
      elevation: 50,
      
      child: ListView(
        children: [
          _drawerItem(context, 'Home', RoutesName.homeScreen),
          _drawerItem(context, 'Post Property For Free', RoutesName.loginScreen),
          _drawerItem(context, 'Plans', RoutesName.signUpScreen),
          _drawerItem(context, 'Log In', RoutesName.loginScreen),
          _drawerItem(context, 'New User', RoutesName.signUpScreen),
          _drawerItem(context, 'Contacts', RoutesName.contactsScreen),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, String routeName) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName); // Navigate via routes
      },
    );
  }
}
