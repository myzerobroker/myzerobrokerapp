import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/drawer/drawer_cubit.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/header_widget.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/responsive_layout.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/search_form.dart';
import 'package:my_zero_broker/presentation/widgets/drawer_content.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

class HomeScreen extends StatelessWidget {
  final AwesomeDrawerBarController controller = AwesomeDrawerBarController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => DrawerCubit(),
      child: Scaffold(
        appBar: AppBar(
          
          centerTitle: true,
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "REAL ESTATE, ",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.059,
                  ),
                ),
                TextSpan(
                  text: "SIMPLIFIED",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 116, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.059,
                  ),
                ),
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: ColorsPalette.appBarColor,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              controller.toggle!(); // Toggle the drawer
            },
          ),
        ),
        body: BlocBuilder<DrawerCubit, DrawerEvent>(
          builder: (context, state) {
            return ResponsiveLayout(
              mobileScreen: AwesomeDrawerBar(
                controller: controller,
                menuScreen: DrawerContent(), // Drawer content widget
                mainScreen: _buildMainScreen(state),
                borderRadius: 24.0,
                showShadow: true,
                angle: -20.0,
                backgroundColor: const Color.fromARGB(255, 81, 9, 9),
              ),
              tabletScreen: AwesomeDrawerBar(
                controller: controller,
                menuScreen: DrawerContent(),
                mainScreen: _buildMainScreen(state),
                backgroundColor: Colors.blue,
              ),
              desktopScreen: AwesomeDrawerBar(
                controller: controller,
                menuScreen: DrawerContent(),
                mainScreen: _buildMainScreen(state),
                backgroundColor: Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the main screen based on the drawer state
  Widget _buildMainScreen(DrawerEvent state) {
    // Define content for different states
    Widget mainContent;

    switch (state) {
      case DrawerEvent.home:
        mainContent = Column(
          children: [
            HeaderWidget(), // Header widget
            SearchForm(),   // Search form widget
          ],
        );
        break;
      case DrawerEvent.postProperty:
        mainContent = Center(
          child: Text(
            'Post Property Screen',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
        break;
      case DrawerEvent.settings:
        mainContent = Center(
          child: Text(
            'Settings Screen',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
        break;
      default:
        mainContent = Center(
          child: Text(
            'Welcome to Real Estate Simplified!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
    }

    return SingleChildScrollView(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: mainContent,
      ),
    );
  }
}
