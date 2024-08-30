# my_pro

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# GetX
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


[Initial Screen]
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
);
},
);
}

_body() {}
}
```

Controller
```dart
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class QrScannerController extends GetxController
{

@override
void init() {    }
}
```
Binding

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
List implementation  
Controller
final List<String> entries = <String>['Mumbai, Maharashtra', 'Haryana, Punjab', 'Mohali, Punjab','Chandigarh, Chandigarh'];

Screen
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
);
}
);


Update UI
Screen

//Return type
FutureBuilder<ProfileResponse>(
//Api call to wait
future: controller.profileGetApi(),
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
],
);
}
if (snapshot.connectionState == ConnectionState.waiting) {
return shimmerView();
}
return shimmerView();
});

Api call
Controller

Future<ProfileResponse> profileGetApi()async{
try {
var id = localStorage.read(SharedPrefConstant().id);
Response response = await HttpsService().getDio().get(BASE_URL + profilePoint+id);
if (response.statusCode == 200) {
profileResponse = ProfileResponse.fromJson(response.data);
// update(["update"]);
}
}
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
}
}
return  profileResponse!;
}


Delete Controller
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


Spinner
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
),
),)
);
}

Specific ui block update

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
}
},
inputType: TextInputType.number,
controller: controller.manualAnalysisControllerList[index],
labelText: controller.varietyList[commodityItemIndex].analysis![index].display!.manualResult!.displayname!,
hint:controller.varietyList[commodityItemIndex].analysis![index].display!.manualResult!.displayname!

);

If update from controller

update(["manualAnalysis"]);


Api call

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
}
}
return coursesModel!;
}


=================>

Align one item right in column
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

===================>


OnTap
getInkWell(
widget:commonText(
forgotLoginStr.tr,
align:TextAlign.right,),
ontap:(){ }
),

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

Move to next screen

Get.toNamed(AppRoutes.PROFILESCREEN);

Get.offAllNamed(AppRoutes.MAINSCREEN);

Clear the screen data on back press, Deleting controller

Future.delayed(Duration(seconds: 2)).then((value) {
Get.delete<LoginController>();
});



Pass data to second screen
Passing data

Get.toNamed(AppRoutes.WEBPAGE, arguments: {
"inspectionId": "",
"taskId": payload.id,
"jobId": payload.jobid,
"inspectionId": payload.inspectionId,
"formId": payload.formId
})!

Get data in second screen
Var taskId= Get.arguments["taskId"];
Var jobId= Get.arguments["jobId"];
Var formId= Get.arguments["formId"];


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




