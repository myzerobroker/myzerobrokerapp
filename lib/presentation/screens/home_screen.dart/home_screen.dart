import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/drawer/drawer_cubit.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/advertisements_carousel.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/enquiry_form.dart'; // Ensure correct import
import 'package:my_zero_broker/presentation/screens/home_screen.dart/enquiry_grids.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/header_widget.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/responsive_layout.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/search_form.dart';
import 'package:my_zero_broker/presentation/widgets/drawer_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AwesomeDrawerBarController controller = AwesomeDrawerBarController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrawerCubit(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 254, 254),
        body: BlocBuilder<DrawerCubit, DrawerEvent>(
          builder: (context, state) {
            return ResponsiveLayout(
              mobileScreen: AwesomeDrawerBar(
                controller: controller,
                menuScreen: DrawerContent(),
                mainScreen: _buildMainScreenWithScrollableAppBar(state),
                borderRadius: 24.0,
                showShadow: true,
                angle: -20.0,
                backgroundColor: const Color.fromARGB(255, 81, 9, 9),
              ),
              tabletScreen: AwesomeDrawerBar(
                controller: controller,
                menuScreen: DrawerContent(),
                mainScreen: _buildMainScreenWithScrollableAppBar(state),
                backgroundColor: Colors.blue,
              ),
              desktopScreen: AwesomeDrawerBar(
                controller: controller,
                menuScreen: DrawerContent(),
                mainScreen: _buildMainScreenWithScrollableAppBar(state),
                backgroundColor: Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainScreenWithScrollableAppBar(DrawerEvent state) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 100.0,
          pinned: true,
          elevation: 10,
          floating: true,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "REAL ESTATE, ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: "SIMPLIFIED",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 116, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              controller.toggle!(); // Toggle the drawer
            },
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _buildMainContent(state),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the main content based on the drawer state
  Widget _buildMainContent(DrawerEvent state) {
    switch (state) {
      case DrawerEvent.home:
        return Stack(
          children: [
       
            Column(
              children: [
                   AdvertisementsCarousel(),
                HeaderWidget(),
                SearchForm(),
            
                EnquiryGrids(
                  onSubjectSelected: (String subject, String img) {
                    EnquiryFormDialog.showEnquiryForm(context, subject, img); // Use correct class name here
                  },
                ),
              ],
            ),
          ],
        );
      default:
        return Center(
          child: Text(
            'Welcome to Real Estate Simplified!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
    }
  }
}
