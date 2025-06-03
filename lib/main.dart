import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/invoice/invoice_bloc.dart';
import 'package:my_zero_broker/bloc/location/location_bloc.dart';
import 'package:my_zero_broker/bloc/login/login_bloc.dart';
import 'package:my_zero_broker/bloc/my_listing/my_listing_bloc.dart';
import 'package:my_zero_broker/bloc/post_builder/post_builder_bloc.dart';
import 'package:my_zero_broker/bloc/post_farmland/post_farmland_bloc.dart';
import 'package:my_zero_broker/bloc/post_property_details/post_property_details_bloc.dart';
import 'package:my_zero_broker/bloc/search_property/search_property_bloc.dart';
import 'package:my_zero_broker/bloc/user_details/fetch_user_details_bloc.dart';
import 'package:my_zero_broker/bloc/video/video_bloc.dart';
import 'package:my_zero_broker/config/routes/routes.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); 
  // set the rotation to only portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashCubit()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => PostPropertyDetailsBloc()),
        BlocProvider(create: (context) => FetchUserDetailsBloc()),
        BlocProvider(
          create: (context) => LocationBloc(),
        ),
        BlocProvider(create: (context) => SearchPropertyBloc()),
          BlocProvider(create: (context) => PostFormladBloc()),
          BlocProvider(create: (context) => MyListingBloc()),
            BlocProvider(create: (context) => PostBuildersDetailsBloc()),
            BlocProvider(create: (context) => VideoBloc()),
            BlocProvider(create: (context) => InvoiceBloc()),
      
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Zero Broker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: RoutesName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
