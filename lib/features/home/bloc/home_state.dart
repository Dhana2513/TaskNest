class HomeStates {}

class InitialState extends HomeStates {}

class UpdateState extends HomeStates {
  final int counter;

  UpdateState(this.counter);
}
