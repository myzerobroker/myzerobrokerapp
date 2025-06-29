import 'dart:convert';

import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/bloc/drawer/drawer_cubit.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/advertisements_carousel.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/enquiry_form.dart'; // Ensure correct import
import 'package:my_zero_broker/presentation/screens/home_screen.dart/enquiry_grids.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/header_widget.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/responsive_layout.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/search_form.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/video_player_widget.dart';
import 'package:my_zero_broker/presentation/widgets/drawer_content.dart';
import 'package:my_zero_broker/presentation/widgets/footer.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

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
        backgroundColor: ColorsPalette.bgColor,
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
          backgroundColor: ColorsPalette.bgColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "REAL ESTATE, ",
                    style: TextStyle(
                      color: ColorsPalette.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: "SIMPLIFIED",
                    style: TextStyle(
                      color: ColorsPalette.primaryColor.withOpacity(0.5),
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

  Future<int> _getEnquiryStatus() async {
    try {
      final response = await http
          .get(Uri.parse('https://myzerobroker.com/api/enquiry-status'));
      if (response.statusCode == 200) {
        final json = response.body;
        final enquiryStatus = jsonDecode(json);
        return enquiryStatus['status'] ?? 0; // Default to 0 if
      } else {
        return 0; // Enquiry status not available
      }
    } catch (e) {
      print('Error fetching enquiry status: $e');
      return 0; // Error occurred
    }
  }

  /// Builds the main content based on the drawer state
  Widget _buildMainContent(DrawerEvent state) {
    switch (state) {
      case DrawerEvent.home:
        return Stack(
          children: [
            Column(
              children: [
                HeaderWidget(),
                SearchForm(),
                AdvertisementsCarousel(),
                VideoPlayerScreen(),
                FutureBuilder(
                  future: _getEnquiryStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final enquiryStatus = snapshot.data as int;
                      if (enquiryStatus == 1) {
                        return EnquiryGrids(
                          onSubjectSelected: (String subject, String img) {
                            EnquiryFormDialog.showEnquiryForm(context, subject,
                                img); // Use correct class name here
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
                FooterWidget(),
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
