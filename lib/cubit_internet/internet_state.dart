abstract class InternetState{}
class InternetInitialState extends InternetState {}
class InternetLostState extends InternetState {}
class InternetGainState extends InternetState {}


/* There no data in state class you can use enum
*
* enum InternetState{Initial,Lost,Gain}
*/