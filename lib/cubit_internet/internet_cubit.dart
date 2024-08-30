import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum InternetStateCubit{Initial,Lost,Gain}

/*No events needed ==> trigger states
* Function emit it any time  */
class InternetCubit extends Cubit<InternetStateCubit>{
  StreamSubscription<List<ConnectivityResult>>? subscription;
  final Connectivity _connectivity= Connectivity();
  InternetCubit() :super(InternetStateCubit.Initial){
    subscription= _connectivity.onConnectivityChanged.listen((connection) {
      if(connection.contains(ConnectivityResult.mobile) || connection.contains(ConnectivityResult.wifi))
      {
        emit(InternetStateCubit.Gain);
      }
      else
      {
        emit(InternetStateCubit.Lost);
      }
    });
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
