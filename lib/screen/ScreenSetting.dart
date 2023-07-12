import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter_app/database/shared_preferences_service.dart';
import 'package:flutter_app/color_service.dart';

// StatelessWidget은 변화지 않는 화면을 작업할 때 사용.
// 변화는 화면을 작업 하고싶을 경우에는 StatefulWidget을 사용.
class ScreenSetting extends StatelessWidget {
  const ScreenSetting({super.key});

  // MaterialApp = 앱으로서 기능을 할 수 있도록 도와주는 뼈대
  @override
  Widget build(BuildContext context) {
    SharedPreferencesService.initialize();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
      },
      child : MaterialApp(
        title: "ScreenSetting", // 앱 이름
        debugShowCheckedModeBanner: false, // 타이틀 바 우측 띠 제거

        // 앱의 기본적인 테마를 지정
        theme: ThemeData(
          primarySwatch: ColorService.createMaterialColor(const Color(0xff265A52)), // priamrySwatch 기본적인 앱의 색상을 지정
        ),

        home: MySettingWidget(), // 앱이 실행될 때 표시할 화면의 함수를 호출
      ),
    );
  }
}

// 앱이 실행 될때 표시할 화면의 함수
class MySettingWidget extends StatefulWidget {
  const MySettingWidget({super.key});

  @override
  State<MySettingWidget> createState() => MySettingWidgetState();
}

class MySettingWidgetState extends State<MySettingWidget> {

  final TextEditingController myWeightGoalController = TextEditingController();
  final TextEditingController myCurrentHeightController = TextEditingController();
  double goalWeight = 0.0 ;
  double currentHeight = 0.0;

  @override
  void initState() {
    super.initState();
    getUserGoalWeight();
    getCurrentHeight();
  }

  Future<void> getUserGoalWeight() async {
    final double savedGoalWeight = SharedPreferencesService.getGoalWeight();
    setState(() {
      goalWeight = savedGoalWeight;
    });
  }

  Future<void> _saveUserGoalWeight() async {
    final double newGoalWeight = double.tryParse(myWeightGoalController.text) ?? 0.0;
    await SharedPreferencesService.setGoalWeight(newGoalWeight);
    setState(() {
      goalWeight = newGoalWeight;
    });
  }

  Future<void> getCurrentHeight() async {
    final double savedCurrentHeight = SharedPreferencesService.getCurrentHeight();
    setState(() {
      currentHeight = savedCurrentHeight;
    });
  }

  Future<void> _saveCurrentHeight() async {
    final double newCurrentHeight = double.tryParse(myCurrentHeightController.text) ?? 0.0;
    await SharedPreferencesService.setCurrentHeight(newCurrentHeight);
    setState(() {
      currentHeight = newCurrentHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("설정",
          style: TextStyle(
              fontSize: 26
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        toolbarHeight: 70,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu),),
      ),
      body: SingleChildScrollView(
        child: Column(
            children:  [
              Padding(
                padding: EdgeInsets.all(20.0),
                // 목표 몸무게 설정
                child: TextField(
                  controller: myWeightGoalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "목표 몸무게 (kg)",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, //<-- SEE HERE
                    ),
                    hintText: "0.0 kg",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: ColorService().color1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: ColorService().color1),
                    ),
                  ),
                ),
              ),
              // 현재 키 설정
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: myCurrentHeightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "현재 키 (kg)",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, //<-- SEE HERE
                    ),
                    hintText: "0.0 cm",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: ColorService().color1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: ColorService().color1),
                    ),
                  ),
                ),
              ),
              Text("현재 목표 몸무게: $goalWeight kg / 현재 키: $currentHeight cm"),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _saveUserGoalWeight();
                      },
                      child: Text('목표 몸무게 변경')
                  ),
                  SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () {
                        _saveCurrentHeight();
                      },
                      child: Text(' 현재 키 변경')
                  ),
                ],
              )
            ]
        ),
      ),

    );
  }

}
