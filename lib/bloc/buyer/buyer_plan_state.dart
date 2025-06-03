part of 'buyer_plan_bloc.dart';

sealed class BuyerPlanState extends Equatable {
  const BuyerPlanState();

  @override
  List<Object> get props => [];
}

final class BuyerPlanInitial extends BuyerPlanState {}

final class BuyerPlanLoading extends BuyerPlanState {}

final class BuyerPlanSuccess extends BuyerPlanState {
  final String message; 
  BuyerPlanSuccess({required this.message});
}


final class BuyerPlanError extends BuyerPlanState {
  final String message; 
  BuyerPlanError({required this.message});

  @override
  List<Object> get props => [message];
}