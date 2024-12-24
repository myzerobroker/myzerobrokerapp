
import 'package:equatable/equatable.dart';

sealed class PostFormladState extends Equatable {
  const PostFormladState();
  
  @override
  List<Object> get props => [];
}

final class PostFormladInitial extends PostFormladState {}
final class PostFormladsLoading extends PostFormladState{}
final class PostFormladSuccessState extends PostFormladState{
  final String successMessage;
  PostFormladSuccessState({required this.successMessage});
  
}
final class PostFormladFailureState extends PostFormladState{
  final String failureMessage;
  PostFormladFailureState({required this.failureMessage}); 
}
