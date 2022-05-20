// ignore_for_file: must_be_immutable

part of "admin_data_bloc.dart";

enum AdminDataStatus { initial, loading, loaded, error }

class AdminDataStates extends Equatable {
  AdminDataStatus status;

  AdminDataStates({
    this.status = AdminDataStatus.initial,
  });

  @override
  List<Object?> get props => [];
}

class StartDataOperationState extends AdminDataStates {
  StartDataOperationState({
    AdminDataStatus status = AdminDataStatus.initial,
  }) : super(status: status);

  factory StartDataOperationState.initial() {
    return StartDataOperationState(status: AdminDataStatus.initial);
  }

  @override
  List<Object?> get props => [];
}
