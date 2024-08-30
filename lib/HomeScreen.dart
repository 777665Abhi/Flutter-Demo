import 'package:flutter/material.dart';
import 'package:my_pro/web_socket/WebSocketScreen.dart';

import 'bloc_internet/InternetCheckScreen.dart';
import 'cubit_internet/InternetCheckScreenCubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(child: Scaffold(body: SafeArea(child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => InternetCheckScreen()));
        },
          child: const Text(
            'Bloc',
            style: TextStyle(color: Colors.black, fontSize: 13.0),
          ),
        ),
      ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => InternetCheckScreenCubit()));
            },
            child: const Text(
              'Cubit',
              style: TextStyle(color: Colors.black, fontSize: 13.0),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebSocketScreen()));
            },
            child: const Text(
              'Web Socket',
              style: TextStyle(color: Colors.black, fontSize: 13.0),
            ),
          ),
        ),
      ],),
    ),),)
    );
  }
}
