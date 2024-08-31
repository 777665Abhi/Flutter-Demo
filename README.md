# Flutter Doc.

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

class QrScannerScreen extends **GetView<QrScannerController>** {
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
void init() {    }
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
