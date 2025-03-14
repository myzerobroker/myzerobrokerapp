import 'package:flutter/material.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerContent extends StatefulWidget {
  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  final key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      key: key,
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
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/my_zero_broker_logo (2).png",
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Visibility(
                  visible: locator.get<UserDetailsDependency>().id != -1,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${locator.get<UserDetailsDependency>().userModel?.user?.name}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              locator
                                      .get<UserDetailsDependency>()
                                      .userModel
                                      ?.user
                                      ?.email ??
                                  '',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to the profile update page
                            Navigator.pushNamed(
                                context, RoutesName.updateProfilePage);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => key.currentState!.closeDrawer(),
                  child: _drawerItem(
                      context, 'Home', RoutesName.homeScreen, Icon(Icons.home)),
                ),
                Divider(color: Colors.grey.shade100),
                _drawerItem(context, 'Shortlisted Property',
                    RoutesName.shortlisted, Icon(Icons.check)),
                Divider(color: Colors.grey.shade100),
                _drawerItem(context, 'My Listings', RoutesName.myListing,
                    Icon(Icons.book)),
                Divider(color: Colors.grey.shade100),
               _drawerItem(
  context,
  'Post Property For Free',
  locator.get<UserDetailsDependency>().id != -1
      ? RoutesName.postpropertyScreen
      : null, // Set route to null if user is not logged in
  Icon(Icons.add),
  isLoginRequired: true, // Add this flag
),

                Divider(color: Colors.grey.shade100),
                ExpansionTile(
                  leading: Icon(Icons.payment),
                  title: Text('Plans'),
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Buyers Plan'),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.buyersPlanScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading: Icon(Icons.store),
                      title: Text('Sellers Plan'),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.sellersPlanScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading: Icon(Icons.man),
                      title: Text("Owner's Plan"),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.ownersPlansScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading: Icon(Icons.person_2),
                      title: Text("Tenant's Plan"),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.tenantPlanScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading: Icon(Icons.person_2_outlined),
                      title: Text("Plot Seller's Plan"),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.plotSellerPlanScreen);
                      },
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade100),
                _drawerItem(context, 'Contacts', RoutesName.contactsScreen,
                    Icon(Icons.contact_page)),
                Divider(color: Colors.grey.shade100),
                locator.get<UserDetailsDependency>().id != -1
                    ? _drawerItem(context, "Log Out", RoutesName.homeScreen,
                        Icon(Icons.logout))
                    : _drawerItem(context, 'Log In', RoutesName.loginScreen,
                        Icon(Icons.login)),
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
    BuildContext context, String title, String? routeName, Icon icon,
    {bool isLoginRequired = false}) {
  return ListTile(
    leading: icon,
    title: Text(title),
    onTap: () async {
      if (isLoginRequired && locator.get<UserDetailsDependency>().id == -1) {
        Future.delayed(Duration.zero, () {
          Snack.show("Please Login", context);
        });
        return;
      }

      if (title == "Log Out") {
        locator.get<UserDetailsDependency>().id = -1;
        locator.get<UserDetailsDependency>().userModel = null;
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.remove("userId");
        Navigator.pushNamed(context, RoutesName.homeScreen);
        return;
      }

      if (routeName != null) {
        Navigator.pushNamed(context, routeName);
      }
    },
  );
}
}
