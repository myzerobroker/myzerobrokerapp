import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_zero_broker/bloc/drawer/drawer_cubit.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';

class DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Iconsax.home4, color: Colors.white),
            title: Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.read<DrawerCubit>().showHome();
            },
          ),
          ListTile(
            leading: Icon(Icons.post_add, color: Colors.white),
            title: Text('Post Property', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pushNamed(RoutesName.postpropertyScreen);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.read<DrawerCubit>().showSettings();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Contact us', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.read<DrawerCubit>().showContacts();
            },
          ),
        ],
      ),
    );
  }
}
