# Flutter Doc.
[GetX:](#GetX).

[BLOC](#BLOC)

[Async programing](#Asynchronous-programming)

[List Implementation](#List-implementation)

[Ui update](#Update-UI)

[FLutter Detail Doc](#FLutter-Detail-Doc)

## GetX
It  provides a combination of State Management, Dependency Injection and Route Management solutions that work great together.
GetxController which extends DisposableInterface.


The three pillars of GetX
[State management]: GetX has two state managers. One is a simple state manager used with the GetBuilder function, and the other is a reactive state manager used with Getx or Obx. We will be talking about it in detail below

[Route management]: whether navigating between screens, showing SnackBars, popping dialog boxes, or adding bottom sheets without the use of context,

[Dependency management]: GetX has a simple yet powerful solution for dependency management using controllers. With just a single line of code, it can be accessed from the view without using an inherited widget or context. Typically, you would instantiate a class within a class, but with GetX, you are instantiating with the Get instance, which will be available throughout your application

Add obs to your variable
Wrap your widget with Obx
var storeName= ‘D-Mart’.obs;
```dart
obx(  () => Flexible(
child: Text(
controller.storeName.value.toString(),
style: const TextStyle(
fontSize: 22, fontWeight: FontWeight.bold) ),
fit: FlexFit.tight,
),),              ],),
```


### Initial Screen
```dart

import 'package:flutter/material.dart';
import '../../constants/exports.dart';
import '../../common_widgets/widgets.dart';

import 'QrScannerController.dart';

class QrScannerScreen extends GetView<QrScannerController> {
const QrScannerScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
return GetBuilder<QrScannerController>(
builder: (_) {
return Scaffold(
appBar: customAppBar(
title: "Scan Detail",
),
body: _body(),
);},);
}

_body() {}
}
```

### Controller
```dart
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class QrScannerController extends GetxController
{

@override
void onInit() {
 super.onInit();
}


}
```
### Binding

```dart
import '../../constants/exports.dart';

class QrScannerBinding extends Bindings {
@override
void dependencies() {
Get.put(QrScannerController());
}
}
```

================>
## List implementation  
### Controller
```dart

final List<String> entries = <String>['Mumbai, Maharashtra', 'Haryana, Punjab', 'Mohali, Punjab','Chandigarh, Chandigarh'];
```

### Screen
```dart

ListView.builder(
itemCount: controller.entries.length,
itemBuilder: (BuildContext context, int index) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Padding(
padding: EdgeInsets.symmetric(horizontal:20  ,vertical: 16),
child: commonText('${controller.entries[index]}')),
Divider(color: dividerColor,)],
);});
```


## Update UI
### Screen
```dart

// One time want to load data when screen open
FutureBuilder<ProfileResponse>(
//Api call to wait
future: controller.profileResponse,
builder: (_, snapshot)
{
if (snapshot.connectionState == ConnectionState.done) {
if(snapshot.hasData)
return Column(
mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
//Draw Ui from api response
_intro(snapshot.data),
_detail(snapshot.data)
],);}
if (snapshot.connectionState == ConnectionState.waiting) {
return shimmerView();
}
return shimmerView();
});
```

### Controller Api call

```dart

Future<ProfileResponse>  profileResponse

@override
void init() {
// Want to trigger api only once, when screen open
profileResponse=profileGetApi();
 }

Future<ProfileResponse> profileGetApi()async{
try {
var id = localStorage.read(SharedPrefConstant().id);
Response response = await HttpsService().getDio().get(BASE_URL + profilePoint+id);
if (response.statusCode == 200) {
profileResponse = ProfileResponse.fromJson(response.data);
// update(["update"]);
}}
catch (e) {
update();
if (e is DioError) {
if (e.response != null) {
var response= json.decode(e.response.toString());
var message =response["error-message"];
if(message!=null){
errorMessage.value =message;
}else {
errorMessage.value =
DioException.handleStatusCode(e.response!.statusCode);
}
}
debugPrint("message is 1 $errorMessage.value");
toast(message: errorMessage.value);
} else {
toast(message: "Something went wrong");
}}
return  profileResponse!;
}
```


### Delete Controller
```dart

return     WillPopScope(
child: Scaffold(
appBar: customAppBar(
title: "Diet Detail",
),
body: _body(),
),
onWillPop: ()async{
return  Get.delete<DietPlanDetailController>();
}
);
```



### Spinner
```dart
_spinner() {
return Padding(
padding: const EdgeInsets.all(8.0),
Child:
//Container decoration to make spinner
Center(
child: Container(
padding: EdgeInsets.symmetric(horizontal: 10.0),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(15.0),
border: Border.all(
color: Colors.orange, style: BorderStyle.solid, width: 1),
),
child: DropdownButton<String>(
value: controller.dropdownValue,
icon: const Icon(Icons.arrow_drop_down),
elevation: 16,
style: const TextStyle(color: Colors.orange),
isExpanded:true,
onChanged: (String? value) {
controller.dropdownValue = value!;
controller.update();
},
items: controller.dropdownList
.map<DropdownMenuItem<String>>((String value) {
return DropdownMenuItem<String>(
value: value,
child: Text(value),
);
}).toList(),
),),)
);}
```

### Specific ui block update
```dart

GetBuilder<DynamicDtrController>(
id:"manualAnalysis",
builder: (_){
return          CommonTextField(
showFloating: false,
textColor:controller.toleranceLimitList[index]==true?green: redColor,
onChanged: (value){
if(double.parse(value)<=controller.varietyList[commodityItemIndex].analysis![index].display!.manualResult?.toleranceLimit!.toDouble())
{
controller.toleranceLimitList[index]=true;
controller.update(["manualAnalysis"]);
}
else {
controller.toleranceLimitList[index]=false;
controller.update(["manualAnalysis"]);
}},
inputType: TextInputType.number,
controller: controller.manualAnalysisControllerList[index],
labelText: controller.varietyList[commodityItemIndex].analysis![index].display!.manualResult!.displayname!,
hint:controller.varietyList[commodityItemIndex].analysis![index].display!.manualResult!.displayname!
);
```

If update from controller

update(["manualAnalysis"]);


Api call
```dart

Future<CoursesModel> courseApiCall() async {
try {
final SharedPreferences prefs = await _prefs;
loginCondition = prefs.getBool('isLogin')!;
dio.interceptors.add(LoggingInterceptor());
var url =
"https://account.exerciseera.com/request/search/onlineCourse?name=&min=&max=&cat=&gender=&level=&language=";

Response response = await dio.get(url);
if (response.statusCode == 200) {
coursesModel = CoursesModel.fromJson(response.data);
}
} catch (e) {
if (e is DioError) {
DioException.fromDioError(e);
courseErrorMessage.value = DioException.errorMessage!;
courseErrorMessage.value =
DioException.handleStatusCode(e.response!.statusCode);
toast(message: courseErrorMessage.value);
} else {
toast(message: "Something went wrong");
}}
return coursesModel!;
}
```

=================>

Align one item right in column
```dart

indicatorDialog() {
return commonDialogs(
radius: 20.0,
body: Column(
//To move all items left
crossAxisAlignment: CrossAxisAlignment.start,
children: [
commonText(completionRate.tr,
align: TextAlign.start,
style: GoogleFonts.poppins(
textStyle: TextStyle(
fontSize: font_24,
fontWeight: FontWeight.w400,
color: black))),
sizedBox(height: margin_16),
getInkWell(
ontap: () {
Get.back();
},
//To move one item right
widget: Align(
alignment: Alignment.centerRight,
child: commonText(okay.tr,
style: GoogleFonts.poppins(
textStyle: TextStyle(
fontSize: font_14,
fontWeight: FontWeight.w600,
color: primaryColor)))))
]));
}
```

===================>


OnTap
```dart
getInkWell(
widget:commonText(
forgotLoginStr.tr,
align:TextAlign.right,),
ontap:(){ }
),
```


CommonText
commonText(buttonText, style:GoogleFonts.poppins(
textStyle: TextStyle(
color: textColor??white,
fontSize: font_16,
fontWeight: FontWeight.w600,
height: 1.5
)
)),


Dialog ui
```dart
informationDialog() {
return commonDialogs(
radius: 20.0,
body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//Title
commonText(completionRate.tr,
align: TextAlign.start,
style: GoogleFonts.poppins(
textStyle: TextStyle(

                   fontSize: font_24,
                   fontWeight: FontWeight.w400,
                   color: black))),
       sizedBox(height: margin_16),
//Detail msg
commonText(completionDetail.tr,
maxLines:3,
style: GoogleFonts.poppins(
textStyle: TextStyle(
fontSize: font_14,
fontWeight: FontWeight.w400,
color: sampleIDColor))),
sizedBox(height: margin_24),
//Click buttons
getInkWell(
ontap: () {
Get.back();
},
widget: Align(
alignment: Alignment.centerRight,
child: commonText(okay.tr,
style: GoogleFonts.poppins(
textStyle: TextStyle(
fontSize: font_14,
fontWeight: FontWeight.w600,
color: primaryColor)))))
]));
}
```

Move to next screen
```dart

Get.toNamed(AppRoutes.PROFILESCREEN);

Get.offAllNamed(AppRoutes.MAINSCREEN);

Clear the screen data on back press, Deleting controller

Future.delayed(Duration(seconds: 2)).then((value) {
Get.delete<LoginController>();
});

```


Pass data to second screen
Passing data
```dart

Get.toNamed(AppRoutes.WEBPAGE, arguments: {
"inspectionId": "",
"taskId": payload.id,
"jobId": payload.jobid,
"inspectionId": payload.inspectionId,
"formId": payload.formId
})!
```

Get data in second screen
```dart

Var taskId= Get.arguments["taskId"];
Var jobId= Get.arguments["jobId"];
Var formId= Get.arguments["formId"];

```

Android build generation
flutter build apk --release
flutter build apk


PrettyDioLogger
var dio =Dio();
dio.interceptors.add(PrettyDioLogger());


CommonTextField as Toolbar
_topSearchView() {
return setPadding(
leftPadding: margin_10,
rightPadding: margin_10,
topPadding: margin_20,
bottomPadding: margin_0,
widget: CommonTextField(
fillColor: searchEditColor,
isFilled: true,
enable: true,
readOnly: true,

       prefix: IconButton(
         icon: Icon(
           Icons.menu,
         ),
         onPressed: () {
           controller.scaffoldKey.currentState!.openDrawer();
         },
       ),
       suffix: getInkWell(
         ontap: () {
           Get.toNamed(AppRoutes.PROFILESCREEN);
         },
         widget: GetBuilder<MainScreenController>(
             id: 'ProfileImage',
             builder: (_) {
               return setPadding(
                   rightPadding: margin_16,
                   widget: assetImage(
                           image: profilePicAst,
                           height: 32.0,
                           width: 32.0,
                         ));
             }),
       ),
       showFloating: false,
       valueTextColor: sampleIDColor,
       inputType: TextInputType.number,
       // hint: searchTraderStr,
       validation: (value) {},
       onChanged: (text) {}),
);


## BLOC

"Clean Architecture" in Flutter, with the BLoC 

"Clean Architecture" in Flutter, combined with the BLoC (Business Logic Component) pattern, is a powerful way to structure your app. It allows for separation of concerns, testability, and scalability. Below is an overview of how you can implement Clean Architecture using BLoC in a Flutter project.

### **1. Project Structure**

The main idea is to separate your code into different layers:

- **Presentation Layer:**  UI and BLoC components.
- **Domain Layer:**  Business logic(what to show and what to do), use cases, and entities.
- **Data Layer:**  Data fetching, repositories, and models.

A typical folder structure might look like this:

```plaintext
lib/
├── core/
│   ├── errors/
│   ├── usecases/
│   └── utils/
├── features/
│   ├── feature1/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   └── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   ├── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   ├── feature2/
│   └── ...
└── main.dart
```

### **2. Domain Layer**

- **Entities:** These are the core classes that represent your business models and contain the most basic attributes.

  class User {
    final String id;
    final String name;

    User({required this.id, required this.name});
  }


- **Use Cases:** These encapsulate a specific piece of business logic.

  class GetUser {
    final UserRepository repository;

    GetUser(this.repository);

    Future<User> call(String id) {
      return repository.getUserById(id);
    }
  }
  

- **Repositories (Interfaces):** Define the contracts for data fetching.

  abstract class UserRepository {
    Future<User> getUserById(String id);
  }


### **3. Data Layer**

- **Models:** These are data representations, often extending or implementing entities.


  class UserModel extends User {
    UserModel({required String id, required String name}) : super(id: id, name: name);

    factory UserModel.fromJson(Map<String, dynamic> json) {
      return UserModel(
        id: json['id'],
        name: json['name'],
      );
    }
  }


- **Repositories (Implementation):** These implement the repository interfaces and fetch data from a data source.


  class UserRepositoryImpl implements UserRepository {
    final RemoteDataSource remoteDataSource;

    UserRepositoryImpl(this.remoteDataSource);

    @override
    Future<User> getUserById(String id) async {
      final userModel = await remoteDataSource.getUserById(id);
      return userModel;
    }
  }

- **Data Sources:** This could be APIs, databases, etc.

  class RemoteDataSource {
    Future<UserModel> getUserById(String id) async {
      // Call API or fetch from database
    }
  }


### **4. Presentation Layer**

- **BLoC:** Manages the state and business logic.

 
  class UserBloc extends Bloc<UserEvent, UserState> {
    final GetUser getUser;

    UserBloc(this.getUser) : super(UserInitial());

    @override
    Stream<UserState> mapEventToState(UserEvent event) async* {
      if (event is GetUserEvent) {
        yield UserLoading();
        try {
          final user = await getUser(event.id);
          yield UserLoaded(user);
        } catch (e) {
          yield UserError("Failed to load user");
        }
      }
    }
  }
  ```

- **UI:** Widgets that represent the user interface.

  ```dart
  class UserPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (_) => UserBloc(),
        child: Scaffold(
          appBar: AppBar(title: Text("User Page")),
          body: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return CircularProgressIndicator();
              } else if (state is UserLoaded) {
                return Text(state.user.name);
              } else if (state is UserError) {
                return Text(state.message);
              }
              return Container();
            },
          ),
        ),
      );
    }
  }
  ```

### **5. Dependency Injection**

Use a dependency injection (DI) framework like `get_it` to manage your dependencies.

```dart
final sl = GetIt.instance;

void init() {
  // BLoC
  sl.registerFactory(() => UserBloc(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());
}
```

### **6. Testing**

Ensure to write unit tests for your use cases, BLoC, and repositories.

- **Use Case Testing**
- **BLoC Testing**
- **Repository Testing**

This structure allows you to keep your app modular, scalable, and maintainable. Each layer is independent, making it easier to test and replace parts of your code without affecting other layers.




Bloc
It’s in middle of UI and DATA

UI → Event (Stream)  add       Bloc  → Request        Data
   ← States               emit                  ← Response
 


##Bloc implementation

State file
```dart

abstract class InternetState{}
class InternetInitialState extends InternetState {}
class InternetLostState extends InternetState {}
class InternetGainState extends InternetState {}
```
Events file
```dart

class InternetEvent{}


class InternetGainEvent extends InternetEvent{}
class InternetLostEvent extends InternetEvent{}
```

Bloc file
```dart
class InternetBloc extends Bloc<InternetEvent,InternetState> {
  StreamSubscription<List<ConnectivityResult>>? subscription;
  final Connectivity _connectivity= Connectivity();
  InternetBloc(): super(InternetInitialState()) {
// Registoring events and setting state 
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    on<InternetGainEvent>((event, emit) => emit(InternetGainState()));

    subscription= _connectivity.onConnectivityChanged.listen((connection) {
      if(connection.contains(ConnectivityResult.mobile) || connection.contains(ConnectivityResult.wifi))
        {
// Adding event, trigger state update
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
```

Screen side updation code
```dart
SafeArea(
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
```
## Cubit implementation

Events are not required in cubit 
In function we can emit state number of time, No need of eents.

**Cubit class**
```dart
/*No events needed ==> trigger states
* Function emit it any time, No Event register  */

enum InternetStateCubit{Initial,Lost,Gain}
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

```
Screen file

```dart
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
```

# Asynchronous programming

Streams and Futures are essential for handling asynchronous programming

**Future** ⇒ deal with a single value that will be available at some point in the future.

**Stream** ⇒  expect multiple values over time (e.g., data from a network request, real-time data, or event streams

### Future
 operation that will eventually be completed.

async and await ⇒ operations in a readable and synchronous manner.

```Dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));  // Simulate a network delay
  return 'Data fetched';
}


void main() async {
  print('Fetching data...');
  String data = await fetchData();
  print('Result: $data');
}
```
**Then** operation to handle future fun

```Dart
void main() { 
print('Fetching data...'); 
fetchData().then((data) {
 print('Result: $data'); 
});
 }
```
### Stream 
A Stream is a sequence of asynchronous events. It can emit multiple values over time, and you can listen to the stream to react to each new value.

**Single-subscription Stream**: Only have **one listener** at a time. Typically used for I/O operations such as HTTP requests.

**Broadcast Stream**: Can have **multiple listeners** and is used for real-time data events like WebSocket connections or user input events.


**StreamController** can be used to manually **control a stream and add events to it.**

Listening: You can listen to a stream using await for or StreamSubscription.

```Dart
Stream<int> numberStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
// Emit the next number
    yield i;    
   }
}

void main() async {
  print('Listening to number stream...');
  await for (int number in numberStream()) {
    print('Number: $number');
  }
}
```
**StreamController**
Manually control a stream using StreamController, which allows you to **add events to the stream**  programmatically.
```Dart
import 'dart:async';

void main() {
  final StreamController<int> controller = StreamController<int>();

  // Listen to the stream
  controller.stream.listen((value) {
    print('Received: $value');
  });

  // Add values to the stream
  controller.add(1);
  controller.add(2);
  controller.add(3);

  // Close the stream when done
  controller.close();
}

```
Manually push values into a stream using **controller.add().**


StreamSubscription
Sometimes you need more control over the listening process, like pausing or canceling a stream. This is done via a StreamSubscription.

```Dart
Stream<int> numberStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void main() {
  StreamSubscription<int> subscription = numberStream().listen((value) {
    print('Received: $value');
  });

  // You can pause, resume, or cancel the subscription
  subscription.onDone(() {
    print('Stream completed');
  });
}
```

Future to Stream
```Dart
  Stream<int> stream = Stream.fromFuture(fetchValue()); 
```
Stream to Future
```Dart
  int firstValue = await numberStream().first; 
```

# Isolate and threads 

Trigger isolate
```Dart
import 'dart:isolate';

// This function runs in a separate isolate
void isolateTask(String message) {
  print('Message from main isolate: $message');
}

void main() async {
  // Spawning a new isolate
**  await Isolate.spawn(isolateTask, 'Hello from main thread!');**
  print('Back to main isolate');
}
```

Comm. btw isolate

```Dart
import 'dart:isolate';

//Isolate task  and send data back
void isolateTask(SendPort sendPort) {
  sendPort.send('Hello from the isolate!');
}

void main() async {
  // Creating a ReceivePort to receive messages
  ReceivePort receivePort = ReceivePort();

  // Spawning an isolate and passing the sendPort
  await Isolate.spawn(isolateTask, receivePort.sendPort);

  // Listening for messages from the isolate
  receivePort.listen((message) {
    print('Message from isolate: $message');
  });
}
```
Compute()

Simpler API for spawning isolates through the compute() function, which abstracts the isolate management and message-passing complexities.

```Dart
import 'package:flutter/foundation.dart';

int performHeavyTask(int value) {
  // Simulating a heavy computation
  return value * 2;
}

void main() async {
  // Running the heavy task in an isolate
  int result = await compute(performHeavyTask, 10);
  print('Result from isolate: $result');
}
```

The compute() function takes two arguments: a top-level function (or static method) and a single argument. It spawns an isolate, runs the function, and returns the result to the main isolate.



Terminating an Isolate

```Dart
 // Spawning an isolate 
ReceivePort receivePort = ReceivePort(); 
myIsolate = await Isolate.spawn(isolateTask, receivePort.sendPort); 

// Kill the isolate after some time 
myIsolate.kill(priority: Isolate.immediate);
```
The compute() function simplifies isolate management, but it doesn’t offer control over its lifecycle beyond waiting for the result.

## FLutter Detail Doc
Here are some important topics related to **Flutter** that can help you become proficient in developing applications using this framework:

### 1. **Flutter Basics**
   - **Introduction to Flutter**: Understanding the framework, its architecture, and advantages.
   - **Dart Programming Language**: Basics of Dart, including syntax, object-oriented programming, async programming, and libraries.
   - **Widgets**: Understanding Stateless and Stateful widgets, layout widgets, input and gesture widgets, and how Flutter uses widgets for UI design.
   - **Flutter App Lifecycle**: Overview of app states (inactive, paused, resumed) and how to handle them.

### 2. **State Management**
   - **setState()**: Using setState to manage local widget state.
   - **InheritedWidget & Provider**: Introduction to lifting state up and using InheritedWidget for passing data to child widgets.
   - **Provider Pattern**: Managing global state using the `provider` package.
   - **Riverpod / Bloc / Cubit**: Advanced state management libraries and patterns, such as Bloc (Business Logic Component) and Cubit.

### 3. **Navigation & Routing**
   - **Basic Navigation**: Understanding `Navigator` and routes, pushing and popping screens.
   - **Named Routes**: Using named routes for navigation between different parts of the app.
   - **Flutter Navigation 2.0**: Deep dive into the declarative approach to routing using `Router` and `RouteInformationParser`.

### 4. **Layouts & UI Design**
   - **Flex Widgets**: Row, Column, and Flex for responsive design.
   - **Grid & List Views**: Implementing scrollable views using `ListView`, `GridView`.
   - **Media Queries**: Responsive layout design for different screen sizes.
   - **Custom Widgets**: Creating reusable custom widgets.
   - **Themes & Styling**: Understanding how to implement themes, colors, and typography.

### 5. **Animations**
   - **Implicit & Explicit Animations**: Using implicit animations like `AnimatedContainer` and explicit animations with `AnimationController`.
   - **Tween Animation**: Using Tweens for smooth transitions.
   - **Hero Animations**: Implementing Hero transitions between screens.

### 6. **Networking & Data Handling**
   - **HTTP Requests**: Using the `http` package for making network calls (GET, POST).
   - **JSON Parsing**: Parsing JSON responses and displaying data.
   - **REST API**: Consuming and integrating REST APIs.
   - **GraphQL**: Using `graphql_flutter` for querying GraphQL APIs.
   - **WebSockets**: Handling real-time data using WebSockets.

### 7. **Database & Storage**
   - **SQLite**: Using `sqflite` package for local database management.
   - **Shared Preferences**: Storing small amounts of data using the `shared_preferences` package.
   - **Firebase**: Firebase Firestore and Realtime Database integration for cloud storage and data management.
   - **Hive**: Lightweight, NoSQL local database package for Flutter apps.

### 8. **Testing & Debugging**
   - **Unit Testing**: Writing and running unit tests for logic and functions.
   - **Widget Testing**: Testing UI components to ensure they work correctly.
   - **Integration Testing**: Testing the entire app flow from start to end.
   - **Debugging Tools**: Using Flutter DevTools, Flutter Inspector, and Dart DevTools for debugging and performance analysis.

### 9. **Flutter Plugins**
   - **Using Plugins**: Adding and using third-party plugins to extend app functionalities.
   - **Creating Custom Plugins**: Developing your own plugins for specific native features (iOS and Android).

### 10. **Platform Integration**
   - **Platform Channels**: Communicating between Flutter and native (Android/iOS) code using platform channels.
   - **Accessing Native APIs**: Integrating native APIs like camera, GPS, sensors using platform-specific code.

### 11. **Performance Optimization**
   - **Lazy Loading**: Efficiently loading lists and images to improve performance.
   - **Isolates**: Using Dart Isolates for background tasks and avoiding UI thread blocking.
   - **Optimizing Build Methods**: Reducing unnecessary widget rebuilds.

### 12. **Firebase Integration**
   - **Authentication**: Firebase Authentication with Google, Facebook, and Email login.
   - **Cloud Messaging**: Implementing push notifications using Firebase Cloud Messaging (FCM).
   - **Analytics & Crashlytics**: Integrating Firebase Analytics and Crashlytics for tracking and error reporting.

### 13. **Deploying Flutter Apps**
   - **Building APK/IPA**: Creating APKs and IPAs for distribution.
   - **App Store/Google Play**: Guidelines and steps to publish Flutter apps on iOS and Android platforms.
   - **CI/CD Pipelines**: Automating deployment using tools like Codemagic, GitHub Actions, and Fastlane.

### 14. **Flutter for Web & Desktop**
   - **Web Support**: Building and deploying Flutter web apps.
   - **Flutter for Desktop**: Introduction to Flutter desktop development (Windows, macOS, Linux).

### 15. **Internationalization**
   - **Localization**: Implementing multi-language support using the `flutter_localizations` package.
   - **Date and Time Formatting**: Handling region-specific date/time formats.

By mastering these topics, you'll be able to build efficient, high-quality, and cross-platform apps using Flutter.
