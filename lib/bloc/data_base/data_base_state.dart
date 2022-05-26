part of 'data_base_bloc.dart';

abstract class DataBaseState extends Equatable {
  const DataBaseState();
}

class DataBaseInitial extends DataBaseState {
  @override
  List<Object> get props => [];
}
