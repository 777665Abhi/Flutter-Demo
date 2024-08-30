import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'internet_cubit.dart';

class InternetCheckScreenCubit extends StatelessWidget {

  const InternetCheckScreenCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        /*  BLOC*/
        // create: (_) => InternetBloc(),

        /*  CUBIT */
        create: (_) => InternetCubit(),
        child:
      Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocBuilder<InternetCubit,InternetStateCubit>(
            builder: (context,state) {
              if(state == InternetStateCubit.Gain)
                {  return Text("Connected ...");}
              else if(state == InternetStateCubit.Lost)
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
