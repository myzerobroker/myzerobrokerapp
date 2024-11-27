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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle:true ,
        title:  Text.rich(
          TextSpan(
                                children: [
                                  TextSpan(text: "REAL ESTATE, ",
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.059, 
                                      
                                    ),),
                                  TextSpan(
                                    text: "SIMPLIFIED",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 116, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.059, 
                                      
                                    ),
                                  ),
                                ],
                              ),),
        elevation: 0,
        backgroundColor: ColorsPalette.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller.toggle!();  // Toggle the drawer
          },
        ),
      ),
      body: BlocProvider(
        create: (_) => DrawerCubit(),
        child: BlocBuilder<DrawerCubit, DrawerEvent>(
          builder: (context, state) {
            return ResponsiveLayout(
              mobileScreen: AwesomeDrawerBar(
                controller: controller,
                menuScreen: DrawerContent(),
                mainScreen: _buildMainScreen(state),
                borderRadius: 24.0,
                showShadow: true,
                angle: -20.0,  // Angle for the drawer when open
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

  // Main screen with a rotation effect based on drawer state
  Widget _buildMainScreen(DrawerEvent state) {
    double angle = 50.0;

    if (state == DrawerEvent.home) {
      angle = 0.0;
    } else if (state == DrawerEvent.postProperty) {
      angle = 120.0;  // Angle when drawer is open
    }

    return Transform(
      transform: Matrix4.rotationY(angle * 3.14 / 180),  // Apply rotation
      alignment: Alignment.center,
      child:  SingleChildScrollView(
      child: Column(
        children: [
          HeaderWidget(), // Header (Logo + Title)
          SearchForm(),   // Main search form
        ],
      ),
    )
    );
  }
}
