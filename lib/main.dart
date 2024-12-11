import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/location/location_bloc.dart';
import 'package:my_zero_broker/bloc/login/login_bloc.dart';
import 'package:my_zero_broker/bloc/post_property_details/post_property_details_bloc.dart';
import 'package:my_zero_broker/config/routes/routes.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_cubit.dart';

void main() {
  setupLocator(); 
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
    
        BlocProvider(
          create: (context) => LocationBloc(),
        ),
        // Add other providers as needed
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



// {
// //   "_token": "St39Ee4JidJqTatyfsEKA9m90V4fPcSSrcLB0O6P",
//   "user_id": 160,
//   "bhk": "2",
//   "property": "Commercial",
//   "purpose": "Sale",
//   "property_type": "Office",
//   "property_age": "Ready Possession",
//   "carpet_area_sqft": "1000",
//   "floor": "4",
//   "balcony":"3",
//   "available_for_lease":"1",
//   "expected_rent":"1",
//   "total_floor": "4",
//   "deposit":"0",
//   "negotiable":"0",
//   "ownership": "On lease",
//   "facing": "North",
//   "area_sqft": "10000",
//   "maintenance":"10000",
//   "furnishing": "Fully-Furnished",
//   "preferred_tenants":"asdsad",
//   "parking_type": "Bike",
//   "water_supply":"Corporation",
//   "description": "good property",
//   "club_house": 1,
//   "intercom": 1,
//   "grated_security":"1",
//   "area":"1112",
//   "expected_price": 5,
//   "maintenance_cost": 10,
//   "price_negotiable": 1,
//   "underloan": "1",
//   "lease_years": 2,
//   "available_from": "2024-12-03",
//   "khata_cert": "Yes",
//   "deed_cert": "Yes",
//   "property_tax": "Yes",
//   "occupancy_cert": "Yes",
//   "city_id": 6,
//   "locality_id": 31,
//   "street": "ABC palace",
//   "photos": []
// }