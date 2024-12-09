import 'package:flutter/material.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';

class DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        elevation: 50,
        child: Column(
          children: [
            DrawerHeader(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                "assets/images/my_zero_broker_logo (2).png",
                height: 100,
              ),
            )),
            Column(
              children: [
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    _drawerItem(context, 'Home', RoutesName.homeScreen,
                        Icon(Icons.home)),
                    Divider(
                      color: Colors.grey.shade100,
                    ),
                    _drawerItem(context, 'Post Property For Free',
                        RoutesName.postpropertyScreen, Icon(Icons.add)),
                    Divider(
                      color: Colors.grey.shade100,
                    ),
                    _drawerItem(context, 'Plans', RoutesName.signUpScreen,
                        Icon(Icons.payment)),
                    Divider(
                      color: Colors.grey.shade100,
                    ),
                    _drawerItem(context, 'New User', RoutesName.signUpScreen,
                        Icon(Icons.person_add)),
                    Divider(
                      color: Colors.grey.shade100,
                    ),
                    _drawerItem(context, 'Contacts', RoutesName.contactsScreen,
                        Icon(Icons.contact_page)),
                    Divider(
                      color: Colors.grey.shade100,
                    ),
                    _drawerItem(context, 'Log Out', RoutesName.loginScreen,
                        Icon(Icons.login)),
                    Divider(
                      color: Colors.grey.shade100,
                    ),
                  ],
                ),
              ],
            )
          ],
        ));
  }

  Widget _drawerItem(
      BuildContext context, String title, String routeName, Icon icon) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, routeName); // Navigate via routes
      },
    );
  }
}
