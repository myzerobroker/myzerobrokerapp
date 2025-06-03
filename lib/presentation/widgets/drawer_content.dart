import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';
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
      backgroundColor: ColorsPalette.bgColor,
      key: key,
      elevation: 50,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: ColorsPalette.bgColor,
                blurRadius: 10.0,
              )
            ]),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/my_zero_broker_logo (2).png",
                    height: 100,
                    width: double.infinity,
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
                              style: TextStyle(
                                  fontSize: 20,
                                  color: ColorsPalette.primaryColor),
                            ),
                            Text(
                              locator
                                      .get<UserDetailsDependency>()
                                      .userModel
                                      ?.user
                                      ?.email ??
                                  '',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: ColorsPalette.primaryColor),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Iconsax.edit_24),
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
                  child: _drawerItem(context, 'Home', RoutesName.homeScreen,
                      Icon(Iconsax.home5, color: ColorsPalette.primaryColor)),
                ),
                Divider(color: Colors.grey.shade100),
                _drawerItem(
                    context,
                    'Shortlisted Property',
                    RoutesName.shortlisted,
                    Icon(Iconsax.heart5, color: ColorsPalette.primaryColor)),
                Divider(color: Colors.grey.shade100),
                _drawerItem(context, 'My Listings', RoutesName.myListing,
                    Icon(Iconsax.menu5, color: ColorsPalette.primaryColor)),
                Divider(color: Colors.grey.shade100),
                _drawerItem(context, 'Invoices', RoutesName.invoicePage,
                    Icon(Iconsax.document4, color: ColorsPalette.primaryColor)),
                Divider(color: Colors.grey.shade100),
                _drawerItem(
                  context,
                  'Post Property For Free',
                  locator.get<UserDetailsDependency>().id != -1
                      ? RoutesName.postpropertyScreen
                      : null, // Set route to null if user is not logged in
                  Icon(Iconsax.shop_add5, color: ColorsPalette.primaryColor),
                  isLoginRequired: true, // Add this flag
                ),
                Divider(color: Colors.grey.shade100),
                ExpansionTile(
                  leading:
                      Icon(Icons.payment, color: ColorsPalette.primaryColor),
                  title: Text(
                    'Plans',
                    style: TextStyle(color: ColorsPalette.primaryColor),
                  ),
                  children: [
                    ListTile(
                      leading: Icon(Iconsax.personalcard5,
                          color: ColorsPalette.primaryColor),
                      title: Text(
                        'Buyers Plan',
                        style: TextStyle(color: ColorsPalette.primaryColor),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.buyersPlanScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading:
                          Icon(Icons.store, color: ColorsPalette.primaryColor),
                      title: Text(
                        'Sellers Plan',
                        style: TextStyle(color: ColorsPalette.primaryColor),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.sellersPlanScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading:
                          Icon(Icons.man, color: ColorsPalette.primaryColor),
                      title: Text(
                        "Owner's Plan",
                        style: TextStyle(color: ColorsPalette.primaryColor),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.ownersPlansScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading: Icon(Icons.person_2,
                          color: ColorsPalette.primaryColor),
                      title: Text(
                        "Tenant's Plan",
                        style: TextStyle(color: ColorsPalette.primaryColor),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.tenantPlanScreen);
                      },
                    ),
                    Divider(color: Colors.grey.shade100),
                    ListTile(
                      leading: Icon(Icons.person_2_outlined,
                          color: ColorsPalette.primaryColor),
                      title: Text(
                        "Plot Seller's Plan",
                        style: TextStyle(color: ColorsPalette.primaryColor),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesName.plotSellerPlanScreen);
                      },
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade100),
                _drawerItem(
                    context,
                    'Contacts',
                    RoutesName.contactsScreen,
                    Icon(
                      Icons.contact_page,
                      color: ColorsPalette.primaryColor,
                    )),
                Divider(color: Colors.grey.shade100),
                locator.get<UserDetailsDependency>().id != -1
                    ? _drawerItem(context, "Log Out", RoutesName.homeScreen,
                        Icon(Icons.logout, color: ColorsPalette.primaryColor))
                    : _drawerItem(context, 'Log In', RoutesName.loginScreen,
                        Icon(Icons.login, color: ColorsPalette.primaryColor)),
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
      title: Text(title,
          style: TextStyle(
            fontSize: 16,
            color: ColorsPalette.primaryColor,
          )),
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
