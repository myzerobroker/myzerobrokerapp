import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  bool _isExpanded = false;

  // Function to show SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Generalized function to launch URLs with detailed error handling
  Future<void> _launchUri(Uri uri, String action) async {
    try {
      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        _showSnackBar('Cannot launch $action: No app available');
        debugPrint('Cannot launch $uri: No app available');
        return;
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      debugPrint('Successfully launched $uri');
    } catch (e, stackTrace) {
      _showSnackBar('Error launching $action: $e');
      debugPrint('Error launching $uri: $e\n$stackTrace');
    }
  }

  // Function to launch URL (for social media)
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    await _launchUri(uri, 'URL');
  }

  // Function to launch phone dialer
  Future<void> _launchPhone(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    await _launchUri(uri, 'phone dialer');
  }

  // Function to launch email
  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    await _launchUri(uri, 'email client');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/my_zero_broker_logo (2).png",
            height: 80,
          ),
          const SizedBox(height: 20),
          // Welcome Text with Show More/Show Less
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to My Zero Broker, a groundbreaking firm that redefines property consultancy. We pride ourselves on operating as mediators rather than traditional property agents or brokers. At My Zero Broker, we\'ve pioneered an innovative online platform that facilitates property searches and listings without any fees attached. Our main objective is to deliver unparalleled e-consulting services with a steadfast commitment to eliminating brokerage charges. At the heart of our ethos lies a dedication to revolutionizing the property consultancy landscape.',
                style: TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              if (_isExpanded)
                const Text(
                  'Here\'s what sets us apart: Mediator Approach: Unlike conventional agents who often prioritize their interests, we act as impartial mediators, ensuring that both property seekers and listers receive fair and transparent treatment throughout the process. Online Platform: Our cutting-edge website provides a user-friendly interface for seamless property exploration and listing. With just a few clicks, users can access a wide range of properties or showcase their own listings without incurring any costs. Free Service: We firmly believe that quality property consultancy should be accessible to all without the burden of brokerage fees. That\'s why we\'ve made it our mission to offer our services entirely free of charge, democratizing access to premium consultancy. Quality E-Consulting: Our team of experts is committed to delivering top-notch e-consulting services tailored to the unique needs of each client. Whether you\'re a property seeker or lister, we leverage our expertise and resources to ensure a smooth and satisfying experience. No Brokerage Policy: Unlike traditional models that often impose hefty brokerage fees, we stand by our pledge to provide brokerage-free services. This commitment not only saves our clients money but also fosters trust and transparency in every transaction. At My Zero Broker, we\'re not just reimagining property consultancy; we\'re revolutionizing it. Join us on our journey to redefine industry standards and experience the future of property consultancy, where quality service reigns supreme and brokerage is a thing of past.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Show less' : 'Show more',
                  style: TextStyle(
                      color: ColorsPalette.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Helpful Links Section
          const Text(
            'HELPFUL LINKS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, RoutesName.loginScreen),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.5,
                      decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, RoutesName.signUpScreen),
                child: const Text(
                  'New User',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.5,
                      decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, RoutesName.postfarmland),
                child: const Text(
                  'Add Property',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.5,
                      decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/plans'),
                child: const Text(
                  'Plans',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.5,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Get Help Section
          const Text(
            'GET HELP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _launchPhone('+917031005005'),
            child: Row(
              children: [
                const Icon(Icons.phone, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '+91-7031005005',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _launchEmail('hi@myzerobroker.com'),
            child: Row(
              children: [
                const Icon(Icons.email, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'hi@myzerobroker.com',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Legal Section
          const Text(
            'LEGAL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, RoutesName.privacyPolicy),
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.5,
                      decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, RoutesName.termsAndCondition),
                child: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.5,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Divider
          const Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 10),
          // Copyright Notice
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '© 2023 MyZeroBroker™. All Rights Reserved.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook, color: Colors.grey),
                    onPressed: () => _launchURL(
                        'https://www.facebook.com/myzerobroker.7031005005?mibextid=ZbWKwL'),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.instagram4, color: Colors.grey),
                    onPressed: () => _launchURL(
                        'https://www.instagram.com/my_zerobroker?igsh=eWJjZ2IwN2YxNHFu'),
                  ),
                ],
              ),
              // main
            ],
          ),
        ],
      ),
    );
  }
}