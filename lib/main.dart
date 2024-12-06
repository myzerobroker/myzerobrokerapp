import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/login/login_bloc.dart';
import 'package:my_zero_broker/config/routes/routes.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/presentation/screens/splash/bloc/splash_cubit.dart';

void main() {
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
