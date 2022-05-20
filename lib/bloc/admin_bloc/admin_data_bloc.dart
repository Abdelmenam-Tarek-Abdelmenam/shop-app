import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_data_event.dart';
part 'admin_data_state.dart';

class AdminDataBloc extends Bloc<AdminDataEvent, AdminDataStates> {
  AdminDataBloc() : super(StartDataOperationState.initial());
}
