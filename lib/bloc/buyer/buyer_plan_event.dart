part of 'buyer_plan_bloc.dart';

sealed class BuyerPlanEvent extends Equatable {
  const BuyerPlanEvent();

  @override
  List<Object> get props => [];
}

class FetchBuyerPlans extends BuyerPlanEvent {
  final String planType;
  final String plan; 
  const FetchBuyerPlans(this.planType, this.plan);

  @override
  List<Object> get props => [];
}
