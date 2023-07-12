import'package:flutter/material.dart';
import 'package:flutter_app/ScreenGraph/ScreenGraphDay.dart';
import 'package:flutter_app/ScreenGraph/ScreenGraphMonth.dart';
import 'package:flutter_app/ScreenGraph/ScreenGraphYear.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_app/color_service.dart';




// StatelessWidget은 변화지 않는 화면을 작업할 때 사용.
// 변화는 화면을 작업 하고싶을 경우에는 StatefulWidget을 사용.
class ScreenGraph extends StatelessWidget {
  const ScreenGraph({super.key});

  // MaterialApp = 앱으로서 기능을 할 수 있도록 도와주는 뼈대
  @override
  Widget build(BuildContext context) {

    // return MaterialApp() -> Material 디자인 테마를 사용
    return MaterialApp(
      title: "ScreenGraph", // 앱 이름
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
  // 지금(오늘) 구하기
  final DateTime today = DateTime.now();
  int _selectedIndex = 0; // 처음에 나올 화면 지정 - 나의 경우 입력 화면을 가장 처음에

  // 이동할 페이지
  final List<Widget> _pages = [
    GraphChartDay(),
    GraphChartMonth(),
    GraphChartYear(),
  ];

  final List<Widget> _bottomTexts = [
    Text("${DateTime.now().month}월", style: TextStyle(color: Colors.white),),
    Text("${DateTime.now().month}월", style: TextStyle(color: Colors.white),),
    Text("${DateTime.now().year}년", style: TextStyle(color: Colors.white),),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    // appBar에 AppBar 위젯을 가져온다.
      appBar: AppBar(title: Text("그래프"), // 타이틀 이름 지정
        centerTitle: true, // 타이틀 이름을 가운데 정렬
        elevation: 0.0, //elevation 속성을 통해 그림자 효과 제어
        // appBar 높이
        toolbarHeight: 50,
        // 좌측 아이콘 버튼
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu),),
      ),

      // 앱의 body 부분
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ToggleSwitch(
              minWidth: 90.0,
              cornerRadius: 20.0,
              inactiveBgColor: ColorService().color1,
              inactiveFgColor: Colors.white,
              initialLabelIndex: null,
              doubleTapDisable: true, // re-tap active widget to de-activate
              totalSwitches: 3,
              labels: const ['일주일', '한달', '1년'],
              // customTextStyles: const [
              //   null,
              //   TextStyle(
              //       color: Colors.brown,
              //       fontSize: 18.0,
              //       fontWeight: FontWeight.w900),
              //   TextStyle(
              //       color: Colors.black,
              //       fontSize: 16.0,
              //       fontStyle: FontStyle.italic)
              // ],
              onToggle: (index) {
                setState(() {
                  _selectedIndex = index!; // index는 item 순서로 0, 1, 2로 구성
                });
              },
            ),
            SizedBox(height: 10),
            Center(
              child: _pages[_selectedIndex], // 페이지와 연결
            ),
            SizedBox(height: 10),
            Container(
                height: 50,
                decoration: BoxDecoration(
                    color: ColorService().color1,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                    child: _bottomTexts[_selectedIndex],
                )
            ),
          ],
        ),
      ),

    );
  }
}


