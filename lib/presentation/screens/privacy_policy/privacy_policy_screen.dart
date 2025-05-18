import 'package:flutter/material.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  // Function to launch email
  Future<void> _launchEmail(String email, BuildContext context) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch email client')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorsPalette.primaryColor.withOpacity(0.6),
              ColorsPalette.bgColor.withOpacity(0.8),
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100.0,
              pinned: true,
              elevation: 0,
              floating: true,
              backgroundColor: ColorsPalette.appBarColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "REAL ESTATE, ",
                        style: TextStyles.subHeadingStyle.copyWith(
                          fontSize: width * 0.045,
                          color: ColorsPalette.textPrimaryColor,
                        ),
                      ),
                      TextSpan(
                        text: "SIMPLIFIED",
                        style: TextStyles.subHeadingStyle.copyWith(
                          fontSize: width * 0.045,
                          color: ColorsPalette.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: ColorsPalette.textPrimaryColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Privacy Policy",
                      style: TextStyles.headingStyle.copyWith(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      "Effective from May 17, 2025",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "To use our services, you must agree to our privacy policy, which includes the following terms:",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "REGISTRATION WITH MY ZERO BROKER",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "To access our website, you must provide your name and contact information at various stages. By using our services, you agree to allow MY ZERO BROKER to use this information for promotions and notifications.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "OTHER REQUIRED INFORMATION",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This website is intended for tenants, landlords, developers, and other individuals. By agreeing to this privacy policy, you confirm that you are not a broker. If you are found to be a broker, MY ZERO BROKER reserves the right to terminate your account at any time or take legal action.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "PERMISSION TO USE YOUR PERSONAL INFORMATION",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "At MY ZERO BROKER, our users' information is very important to us, and its privacy is our top priority. By agreeing to this policy, you grant permission for us to use your personal information for advertisements, offers, and notifications.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "FINANCIAL PERMISSION TO MY ZERO BROKER",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "As MY ZERO BROKER is a service provider, we may charge fees to use certain features of the website. By agreeing to this privacy policy, you consent to the use of non-refundable service charges as a subscriber or user of MY ZERO BROKER's website-based services. You also expressly authorize the MY ZERO BROKER team to contact you via calls, WhatsApp messages, SMS, or emails to your registered email ID. You agree not to file complaints with the National Do Not Call (NDNC) registry for any communications received from MY ZERO BROKER. Additionally, you acknowledge and authorize MY ZERO BROKER to make initial communications to verify the credentials you provide. Until you explicitly request to unsubscribe from MY ZERO BROKER's services or website, the MY ZERO BROKER team retains the right to communicate with you using the authorized contact details you have provided. You agree to indemnify MY ZERO BROKER against any liability arising from such communications, including court cases, legal suits, and all associated legal fees, even if the dispute is not subject to judicial scrutiny. Subscription usage is restricted to the registered user only, and third-party use of a subscription is strictly prohibited.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "PROHIBITED CONDUCT",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "By registering with MY ZERO BROKER, you warrant that you will not engage in the following prohibited activities:\n"
                      "1. Attempt to gain unauthorized access to the site, impersonate another user, or use a false identity or address to access the site.\n"
                      "2. Use the site to violate the intellectual property rights of any person, including posting pirated music, software, or links to such material.\n"
                      "3. Send spam, duplicative, or unsolicited messages in violation of applicable laws.\n"
                      "4. Send or store infringing, obscene, threatening, libelous, or otherwise unlawful material, including content harmful to children or that violates third-party privacy rights.\n"
                      "5. Send or store material containing software viruses, worms, Trojan horses, or other harmful computer code, files, scripts, agents, or programs.\n"
                      "6. Interfere with or disrupt the integrity or performance of the services or the data contained therein.\n"
                      "7. License, sublicense, sell, resell, transfer, assign, distribute, or otherwise commercially exploit or make the service or its content available to any third party.\n"
                      "8. Modify or create derivative works based on the service or its content.\n"
                      "9. Create internet links to the site, or frame or mirror any content on any other server, wireless, or internet-based device.\n"
                      "10. Reverse engineer or access the service to (a) build a competitive product, (b) build a product using similar ideas, features, functions, or graphics, or (c) copy any ideas, features, functions, or graphics of the service.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "SITE LOCAL VERIFICATION",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "MY ZERO BROKER verifies sites using third-party services like Google Maps. We cannot guarantee the accuracy or quality of third-party content. All dealings are between you and third-party businesses, and MY ZERO BROKER is not liable for any damages arising from such interactions.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "ROLE OF MY ZERO BROKER",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "MY ZERO BROKER acts as a third-party coordinator connecting clients with business partners, builders, or service providers. We charge for these services but do not guarantee the quality or integrity of services provided by third-party partners. Any interactions or transactions are solely between you and the third-party partner.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "SPECIAL TERMS AND CONDITIONS",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "1. Brokers and real estate agents are not allowed to log in. Violators will be blocked immediately.\n"
                      "2. OTPs will be sent to registered mobile numbers and email IDs for verification.\n"
                      "3. Information provided, such as photographs, locations, and contact details, may be shared with customers on MY ZERO BROKER.\n"
                      "4. The privacy of your information is our priority.\n"
                      "5. Your mobile number or email ID may be used for advertisements by MY ZERO BROKER.\n"
                      "6. By agreeing to our terms, you allow other users and partners to contact you regarding potential opportunities.\n"
                      "7. Notifications will be sent via email. You can opt out by contacting us at hi@myzerobroker.com.\n"
                      "8. We use standard security measures to protect your personal information but cannot guarantee complete protection.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        const Text(
                          "Contact us at ",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () => _launchEmail('hi@myzerobroker.com', context),
                          child: const Text(
                            'hi@myzerobroker.com',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Text(
                          " to opt out of notifications.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "PERSONAL INFO OF TENANTS",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "To register you on MY ZERO BROKER, we will require your contact number, email address, and residential address. This information will be used to contact you via SMS, WhatsApp, emails, or letters to send welcome letters, bulletins, or offers from our business partners from time to time. As we are only a coordinator, we are not liable for guaranteeing the validity of any offer. The information shared with you will be related to business purposes only. At any time, if you no longer wish to avail of the service, you can email us at ",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _launchEmail('hi@myzerobroker.com', context),
                      child: const Text(
                        'hi@myzerobroker.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      " to deactivate your service.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "FREE SERVICES",
                      style: TextStyles.subHeadingStyle.copyWith(
                        fontSize: 18,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Our website is designed to help prospective tenants discover new rental properties. You may browse some parts of the site even if you have not registered with MY ZERO BROKER. However, you will not be able to contact property owners unless you have logged in as a registered user and paid the required charges.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: ColorsPalette.textSecondaryColor),
                    Text(
                      "This privacy policy is subject to change without notice.",
                      style: TextStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        color: ColorsPalette.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}