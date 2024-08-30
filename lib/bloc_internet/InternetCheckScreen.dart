import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'internet_bloc.dart';
import 'internet_state.dart';

class InternetCheckScreen extends StatelessWidget {

  const InternetCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
        /*  BLOC*/
        create: (_) =>  InternetBloc(),
    child:
      Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocBuilder<InternetBloc,InternetState>(
            builder: (context,state) {
              if(state is InternetGainState)
                {  return Text("Connected ...");}
              else if(state is InternetLostState)
              {  return Text("Not Conected ...");}
              else
              {  return Text("Loading ...");}
            }
          ),
        ),
      ),
    )));
  }
}
