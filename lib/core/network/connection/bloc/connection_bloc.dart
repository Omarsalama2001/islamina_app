import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
part 'connection_event.dart';
part 'connection_states.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionStates> {
  StreamSubscription? _connectivity;
  ConnectionBloc() : super(ConnectionInitial()) {
    on<ConnectionEvent>((event, emit) {
      if (event is ConnectedEvent) {
        emit(ConnectedState(message: "internet connected successfully"));
      } else if (event is NotConnectedEvent) {
        emit(NotConnectedState(message: "you are in offline mode"));
      }
    });

    _connectivity = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result[0] == ConnectivityResult.wifi || result[0] == ConnectivityResult.mobile) {
        add(ConnectedEvent());
      } else {
        add(NotConnectedEvent());
      }
    });
  }
  @override
  Future<void> close() {
    _connectivity!.cancel();
    return super.close();
  }
}
