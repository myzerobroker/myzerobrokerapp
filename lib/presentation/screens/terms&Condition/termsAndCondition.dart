import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: CustomScrollView(
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
                        color: Color.fromARGB(255, 116, 0, 0),
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
              icon: Icon(Icons.arrow_back, color: Colors.black),
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
                    "TERMS AND CONDITION",
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "Effective from August 15, 2019",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "MY ZERO BROKER YOUR PROPERTY FRIEND",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "MY ZERO BROKER is an online-based property search engine. "
                    "In which we will offer online services for buy/rent/sale the property. "
                    "By taking very less service charges, instead of very huge (1 or 2%) brokerage amount. "
                    "To use our services you have to login to our website www.myzerobroker.com and "
                    "you have to provide us your email address & mobile number by sending OTP we will "
                    "confirm your identity. To use our services, you have to accept our terms and conditions. "
                    "The all rights are reserved by my zero broker.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  Text(
                    "OUR MAIN SERVICES",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "User can create only one username & password with register email ID & mobile number. "
                    "After verification of the information our team is having full RIGHTS to accept/reject "
                    "the proposal, for any other reason that MY ZERO BROKER find suitable and which is not "
                    "liable to state or justify. The account created on MY ZERO BROKER is non-transportable and "
                    "its privacy responsibility is held with authorized person only. In any case if we find the "
                    "password & login ID shared with any other person then we will consider it as breach of "
                    "contract, at that time, we will terminate or suspend your account without giving any notification. "
                    "You must immediately notify us if you become aware of unauthorized access to your account.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  Text(
      "PERMISSION TO USE YOUR PERSONAL INFORMATION",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    SizedBox(height: 8),
    Text(
      "At MY ZERO BROKER, our user’s information is very important to us, and its privacy is our first motto. By agreeing to this policy, you are giving permission to use your personal information for advertisement, offers, and notifications.",
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 16),
     Divider(),
    Text(
      "INFORMATION REQUIRED",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    SizedBox(height: 8),
    Text(
      "For registration on MY ZERO BROKER, you must provide your personal details like:\n"
      "a) Current address\n"
      "b) Full Name\n"
      "c) Contact numbers (mobile number)\n"
      "d) Email address\n"
      "The information must be correct, current, accurate, and complete in all respects. Our expert team will verify the details to ensure you are not a broker before granting access to our website.",
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 16),
     Divider(),
    Text(
      "WEB SITE LIABILITY",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    SizedBox(height: 8),
    Text(
      "The profile created by you on MY ZERO BROKER should only contain photographs of the property, detailed addresses, and other essential information about your property requirements. Any inappropriate content such as nudity, profanity, or harassment is strictly prohibited. Legal actions may be taken if violations occur.",
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 16),
     Divider(),
    Text(
      "RIGHTS OF MY ZERO BROKER",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    SizedBox(height: 8),
    Text(
      "In case of any violations, MY ZERO BROKER reserves the right to suspend or terminate your access to our website immediately.",
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 16),
     Divider(),
    Text(
      "SITE LOCAL VERIFICATION",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    SizedBox(height: 8),
    Text(
      "MY ZERO BROKER verifies sites using third-party services like Google Maps. We cannot guarantee the accuracy or quality of third-party content. All dealings are between you and third-party businesses, and MY ZERO BROKER is not liable for any damages arising from such interactions.",
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 16),
     Divider(),
    Text(
      "ROLE OF MY ZERO BROKER",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    SizedBox(height: 8),
    
    Text(
      "MY ZERO BROKER acts as a third-party coordinator connecting clients with business partners, builders, or service providers. We charge for these services but do not guarantee the quality or integrity of services provided by third-party partners. Any interactions or transactions are solely between you and the third-party partner.",
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 16),
     Divider(),
    Text(
      "SPECIAL TERMS AND CONDITIONS",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    SizedBox(height: 8),
    Text(
      "1. Brokers/Real estate agents are not allowed to log in. Violators will be blocked immediately.\n"
      "2. OTPs will be sent to registered mobile numbers and email IDs for verification.\n"
      "3. Information provided such as photographs, locations, and contact details may be shared with customers on MY ZERO BROKER.\n"
      "4. Privacy of your information is our priority.\n"
      "5. Your mobile number or email ID may be used for advertisements by MY ZERO BROKER.\n"
      "6. By agreeing to our terms, you allow other users and partners to contact you regarding potential opportunities.\n"
      "7. Notifications will be sent via email. You can opt out by contacting us at hi@myzerobroker.com.\n"
      "8. We use standard security measures to protect your personal information, but cannot guarantee complete protection.",
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 16,),
     Divider(),
     Text(
      "PERSONAL INFO OF TENANTS",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
     SizedBox(height: 8),
      Text(
      "To register you on MY ZERO BROKER we will require your contact number, email address and residential address. So that we can approach you by sending SMS/what’s app/ Emails or letter so that you will get the welcome letter and bulletin or offers of our business partner time to time. As we are only coordinator, we are not liable for any guaranty of validity of the offer. The info shared to you will only be related to business and nothing else. At any time if you don’t want to avail the service you just have to mail us at hi@myzerobroker.com your service will be deactivated.",
            style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 16),
     Divider(),
    Text(
      "FREE SERVICES",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    SizedBox(height: 8),
    Text(
"Our web-site is designed to help the prospective tenants discover new rental, you many browse some part of the site, even if you have not register with MY ZERO BROKER. However, you will not be able to contact that owner unless you have logged in as a registered and pay the required charges.",
            style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 16),
     Divider(),
     Text(
"This privacy policy is subject to change without notice.",
            style: TextStyle(fontSize: 16, color: Colors.black),
    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}