part of 'connection_bloc.dart';

sealed class ConnectionStates extends Equatable {
  const ConnectionStates();

  @override
  List<Object> get props => [];
}

final class ConnectionInitial extends ConnectionStates {}

// ignore: must_be_immutable
class ConnectedState extends ConnectionStates {
  String message;
  ConnectedState({
    required this.message,
  });
}

// ignore: must_be_immutable
class NotConnectedState extends ConnectionStates {
  String message;
  NotConnectedState({
    required this.message,
  });
}
