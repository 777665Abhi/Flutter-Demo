import 'package:flutter/material.dart';
import 'package:my_pro/cubit_internet/InternetCheckScreenCubit.dart';
import 'package:my_pro/cubit_internet/internet_cubit.dart';
import 'package:my_pro/web_socket/WebSocketScreen.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'HomeScreen.dart';
import 'bloc_internet/InternetCheckScreen.dart';
import 'bloc_internet/internet_bloc.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

/*Bloc and Cubit*/

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: BlocProvider(
  //     /*  BLOC*/
  //       // create: (_) => InternetBloc(),
  //       // child: InternetCheckScreen(),
  //
  //       /*  CUBIT */
  //       create: (_) => InternetCubit(),
  //       child: InternetCheckScreenCubit(),
  //     ),
  //   );
  // }



/*Web Socket implementation*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  HomeScreen(),
    );
  }
}
