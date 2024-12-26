

import 'package:equatable/equatable.dart';

sealed class PostBuildersDetailsState extends Equatable {
  const PostBuildersDetailsState();
  
  @override
  List<Object> get props => [];
}

final class PostBuilderDetailsInitial extends PostBuildersDetailsState {}
final class PostBuilderDetailsLoading extends PostBuildersDetailsState{}
final class PostBuilderDetailsSuccessState extends PostBuildersDetailsState{
  final String successMessage;
  PostBuilderDetailsSuccessState({required this.successMessage});
  
}
final class PostBuilderDetailsFailureState extends PostBuildersDetailsState{
  final String failureMessage;
  PostBuilderDetailsFailureState({required this.failureMessage}); 
}
