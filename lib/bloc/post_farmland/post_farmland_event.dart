

import 'package:equatable/equatable.dart';

sealed class PostFormladEvent extends Equatable {
  const PostFormladEvent();

  @override
  List<Object> get props => [];
}

class PostPropertyEventToApi extends PostFormladEvent{
  final Map<String, dynamic> propertyDetails;
  PostPropertyEventToApi({required this.propertyDetails});
  @override
  List<Object> get props => [propertyDetails];
}