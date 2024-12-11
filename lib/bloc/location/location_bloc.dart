import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/models/city_details_model.dart';
import 'package:my_zero_broker/locator.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<FetchLocationEvent>((event, emit) async {
      emit(LocationLoading());
      final citys = await locator.get<AreaDetailsDependency>().fetchAreas();
      if(citys.isNotEmpty){
        emit(LocationLoaded(cityDetails: citys));
      }
      else{
        emit(LocationError(message: "Error Fetching City Details"));
      }
    });
  }
}
