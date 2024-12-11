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
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 10.0,
              )
            ]),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                "assets/images/my_zero_broker_logo (2).png",
                height: 100,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _drawerItem(context, 'Home', RoutesName.homeScreen, Icon(Icons.home)),
                Divider(color: Colors.grey.shade100),
                _drawerItem(context, 'Post Property For Free',
                    RoutesName.postpropertyScreen, Icon(Icons.add)),
                Divider(color: Colors.grey.shade100),
                ExpansionTile(
                  leading: Icon(Icons.payment),
                  title: Text('Plans'),
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Buyers Plan'),
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.buyersPlanScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading: Icon(Icons.store),
                      title: Text('Sellers Plan'),
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.sellersPlanScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text('Other Plans'),
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.otherPlansScreen);
                      },
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade100),
                _drawerItem(context, 'Contacts', RoutesName.contactsScreen, Icon(Icons.contact_page)),
                Divider(color: Colors.grey.shade100),
                _drawerItem(context, 'Log In', RoutesName.loginScreen, Icon(Icons.login)),
                Divider(color: Colors.grey.shade100),
              ],
            ),
          ),
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, String title, String routeName, Icon icon) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: () {
        if (routeName == RoutesName.homeScreen) {
          return;
        }
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}
