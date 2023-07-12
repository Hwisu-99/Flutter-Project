import'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_app/color_service.dart';

// StatelessWidget은 변화지 않는 화면을 작업할 때 사용.
// 변화는 화면을 작업 하고싶을 경우에는 StatefulWidget을 사용.
class ScreenCalendar extends StatelessWidget {
  const ScreenCalendar({super.key});


  // MaterialApp = 앱으로서 기능을 할 수 있도록 도와주는 뼈대
  @override
  Widget build(BuildContext context) {

    // return MaterialApp() -> Material 디자인 테마를 사용
    return MaterialApp(
      title: "ScreenCalendar", // 앱 이름
      debugShowCheckedModeBanner: false, // 타이틀 바 우측 띠 제거

      // 앱의 기본적인 테마를 지정
      theme: ThemeData(
        primarySwatch: ColorService.createMaterialColor(const Color(0xff265A52)), // priamrySwatch 기본적인 앱의 색상을 지정
      ),

      home: MyWidget(), // 앱이 실행될 때 표시할 화면의 함수를 호출
    );
  }
}

// 앱이 실행 될때 표시할 화면의 함수
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // appBar에 AppBar 위젯을 가져온다.
      appBar: AppBar(title: Text("달력"), // 타이틀 이름 지정
        centerTitle: true, // 타이틀 이름을 가운데 정렬
        elevation: 0.0, //elevation 속성을 통해 그림자 효과 제어
        toolbarHeight: 70,
      ),

      // 앱의 body 부분
      body: content(),

    );
  }

  Widget content(){
    return Column(
      children: [
        TableCalendar(
            rowHeight: 60,
            headerStyle:
              HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            focusedDay: today,
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2025, 12, 30),
        ),

      ],
    );
  }
}


