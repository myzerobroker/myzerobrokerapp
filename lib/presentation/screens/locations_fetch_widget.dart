import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/location/location_bloc.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/home_screen.dart';

class LocationsFetchWidget extends StatefulWidget {
  const LocationsFetchWidget({super.key});

  @override
  State<LocationsFetchWidget> createState() => _LocationsFetchWidgetState();
}

class _LocationsFetchWidgetState extends State<LocationsFetchWidget> {
  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(FetchLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationLoaded) {
          return HomeScreen();
        } else if (state is LocationError) {
          return Scaffold(
            body: Center(
              child: Text(state.message),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
