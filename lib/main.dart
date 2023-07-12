import 'package:flutter/material.dart';

import 'package:flutter_app/screen/ScreenCalendar.dart';
import 'package:flutter_app/screen/ScreenGraph.dart';
import 'package:flutter_app/screen/ScreenInput.dart';
import 'package:flutter_app/screen/ScreenSetting.dart';

import 'color_service.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // MaterialApp = 앱으로서 기능을 할 수 있도록 도와주는 뼈대
  @override
  Widget build(BuildContext context) {

    // return MaterialApp() -> Material 디자인 테마를 사용;
    return MaterialApp(
      title: "MyApp", // 앱 이름
      debugShowCheckedModeBanner: false, // 타이틀 바 우측 띠 제거

      // 앱의 기본적인 테마를 지정
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        primaryColor: Colors.pinkAccent,
        useMaterial3: true,
      ),

      home: MyWidget(), // 앱이 실행될 때 표시할 화면의 함수를 호출
    );
  }
}

// 앱이 실행 될때 표시할 화면의 함수
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  // scaffold = 구성된 앱에서 디자인적인 부분을 도와주는 뼈대

  // 화면 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // 앱의 body 부분
      body: Center(
        child: TabPage(),
      ),
    );
  }
}

// Bottom Navigation Bar
// 동적으로 화면을 변화하므로 StatefulWdiget 사용
class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  int _selectedIndex = 0; // 처음에 나올 화면 지정 - 나의 경우 입력 화면을 가장 처음에

  @override
  void initState() {
    super.initState();
  }

  // 이동할 페이지
  final List<Widget> _pages = [
    ScreenInput(),
    ScreenCalendar(),
    ScreenGraph(),
    ScreenSetting()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: _pages[_selectedIndex], // 페이지와 연결
        ),

        // BottomNavigationBar 위젯
        bottomNavigationBar: BottomNavigationBar(
          // bottomNavigationBar이 보임
          type: BottomNavigationBarType.fixed,
          // bottomNavigationBar item이 4개 이상일 경우

          // 클릭 이벤트
          onTap: _onItemTapped,
          currentIndex: _selectedIndex, // 현재 선택된 index
          selectedItemColor: ColorService().color1,

          // BottomNavigationBarItem 위젯
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.border_color),
              label: '입력'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              label: '달력'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: '그래프'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.brightness_5),
              label: '설정'
            ),
          ],
        )
    );
  }

  void _onItemTapped(int index) {
    // state 갱신
    setState(() {
      _selectedIndex = index; // index는 item 순서로 0, 1, 2로 구성
    });
  }
}