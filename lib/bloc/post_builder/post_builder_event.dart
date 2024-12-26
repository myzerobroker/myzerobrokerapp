
import 'package:equatable/equatable.dart';

sealed class PostBuildersDetailsEvent extends Equatable {
  const PostBuildersDetailsEvent();

  @override
  List<Object> get props => [];
}

class PostBuilderEventToApi extends PostBuildersDetailsEvent{
  final Map<String, dynamic> propertyDetails;
  PostBuilderEventToApi({required this.propertyDetails});
  @override
  List<Object> get props => [propertyDetails];
}