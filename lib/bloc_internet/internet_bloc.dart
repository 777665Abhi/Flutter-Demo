import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'internet_event.dart';
import 'internet_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetBloc extends Bloc<InternetEvent,InternetState> {
  StreamSubscription<List<ConnectivityResult>>? subscription;
  final Connectivity _connectivity= Connectivity();
  InternetBloc(): super(InternetInitialState()) {
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    on<InternetGainEvent>((event, emit) => emit(InternetGainState()));

    subscription= _connectivity.onConnectivityChanged.listen((connection) {
      if(connection.contains(ConnectivityResult.mobile) || connection.contains(ConnectivityResult.wifi))
        {
          add(InternetGainEvent());
        }
      else
        {
          add(InternetLostEvent());
        }
    });
  }

@override
  Future<void> close() {
  subscription!.cancel();
  return super.close();
  }
}