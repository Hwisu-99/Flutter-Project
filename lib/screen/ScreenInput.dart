import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter_app/data/dateweight_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/database/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_app/color_service.dart';

// StatelessWidget은 변화지 않는 화면을 작업할 때 사용.
// 변화는 화면을 작업 하고싶을 경우에는 StatefulWidget을 사용.
class ScreenInput extends StatelessWidget {
  const ScreenInput({super.key});


  // MaterialApp = 앱으로서 기능을 할 수 있도록 도와주는 뼈대
  @override
  Widget build(BuildContext context) {

    // return MaterialApp() -> Material 디자인 테마를 사용
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
      },
      child: MaterialApp(
        title: "ScreenInput", // 앱 이름
        debugShowCheckedModeBanner: false, // 타이틀 바 우측 띠 제거

        // 앱의 기본적인 테마를 지정
        theme: ThemeData(
          primarySwatch: ColorService.createMaterialColor(const Color(0xff265A52)), // priamrySwatch 기본적인 앱의 색상을 지정
        ),

        home: MyWidget(), // 앱이 실행될 때 표시할 화면의 함수를 호출
      ),
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

  // 날짜 데이터 , 몸무게 데이터
   DateTime currentDayDate = DateTime.now();
   String currentDayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
   TextEditingController myWeightController = TextEditingController();

   @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // int currentDataIndex = chartData.indexWhere((data) =>
    // data.date.year == currentDay.year &&
    //     data.date.month == currentDay.month &&
    //     data.date.day == currentDay.day);
    //
    // double pastWeightData = chartData.elementAt(currentDataIndex-1).weight;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar에 AppBar 위젯을 가져온다.
      appBar: AppBar(
        title: Text(
          "입력",
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold
          ),
        ), // 타이틀 이름 지정
        centerTitle: true, // 타이틀 이름을 가운데 정렬
        elevation: 0.0, //elevation 속성을 통해 그림자 효과 제어
        toolbarHeight: 60, // appBar 높이
        // leading: ,
      ),

      // 앱의 body 부분
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            // Text("${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}"
            SizedBox(
              height:60,
              width:300,
              child: ElevatedButton(
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: currentDayDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (newDate == null) return;
                  setState(() {
                    currentDayDate = newDate;
                    currentDayString = DateFormat('yyyy-MM-dd').format(newDate);
                    print(currentDayString);
                    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(currentDayString);
                    print(parsedDate);
                    print(parsedDate.year);
                    print(parsedDate.month);
                    print(parsedDate.day);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorService().color1, //background color of button
                    side: BorderSide(width:3, color:Colors.white70), //border width and color
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder( //to set border radius to button
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: EdgeInsets.all(20) //content padding inside button
                ),
                child: Text(
                  "${currentDayDate.year} ${currentDayDate.month}.${currentDayDate.day} ${DateFormat('E').format(currentDayDate)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                )
              ),
            ),
            SizedBox(height: 10,),
            Form(
                child: Theme(
                  data: ThemeData(
                    primaryColor: ColorService().color1,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      )
                    )
                  ),
                  child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          autofocus: true,
                          controller: myWeightController,
                          decoration: InputDecoration(
                            labelText: "몸무게를 입력하시오",
                            hintText: "미입력",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
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
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "체지방률을 입력하시오",
                            hintText: "미입력",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
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
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 70,),
                        TextField(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "메모",
                            hintText: "미입력",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            // ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1, color: ColorService().color1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1, color: ColorService().color1),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 70,),
                        ButtonTheme(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          minWidth: 400.0,
                          height: 50.0,
                          child: ElevatedButton(
                            // 등록 버튼을 눌렀을 때의 동작
                            // 화면이 떠야됨
                            // 해당 날짜에 이미 몸무게 데이터가 입력되어 있다면 덮어쓰기하시겠습니까?
                            // 해당 날짜에 몸무게 데이터가 입력이 안되어 있으면 바로 DateWeight 데이터를 ScreenGraph.dart로 전송하고 등록이 완료되었습니다 (Dialog 출력)
                            onPressed: () async {
                              double weight = double.tryParse(myWeightController.text) ?? 0.0;
                              bool exists = await isRowExists('dateWeight', 'date', currentDayString);

                              // hasData
                              if(exists){
                                // ignore: use_build_context_synchronously
                                _showdialogA(context, weight, currentDayDate);
                              }
                              else {
                                // ADD
                                await DatabaseHelper.instance.add(
                                  DateWeightData(date: currentDayDate, weight: weight),
                                );
                                // ignore: use_build_context_synchronously
                                _showdialogB(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: ColorService().color1,
                              side: BorderSide(width:3, color:Colors.white70),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              // padding: EdgeInsets.all(50.0),
                            ),
                            child: Text(
                              '등록',
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                                fontSize: 15.0
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),

    );
  }
}

// 이미 데이터가 입력되어 있는 경우 덮어쓰기 다이럴로그 출력
Future<dynamic> _showdialogA(BuildContext context, double weight, DateTime currentDayDate) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Text('이미 데이터가 등록되어 있습니다. 덮어쓰기 하시겠습니까?', style: TextStyle(fontWeight: FontWeight.bold),),
      actions: [
        // 취소 버튼을 누르면 아무 일도 일어나지 않음 (데이터 갱신X)
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소')),
        // 덮어쓰기 버튼을 누르면 chartData 갱신
        ElevatedButton(
            onPressed: () async {
              // UPDATE
              await DatabaseHelper.instance.update(
                DateWeightData(date: currentDayDate, weight: weight),
              );
              Navigator.of(context).pop();
            },
            child: Text('덮어쓰기')),
      ],
    ),
  );
}

// 새로운 데이터를 넘겨주는 경우 출력되는 다이얼로그
Future<dynamic> _showdialogB(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Text('등록이 완료되었습니다'),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('나가기')),
      ],
    ),
  );
}

Future<bool> isRowExists(String tableName, String columnName, dynamic columnValue) async {
  Database db = await DatabaseHelper.instance.database;
  List<Map<String, dynamic>> rows = await db.query(
    tableName,
    columns: [columnName],
    where: '$columnName = ?',
    whereArgs: [columnValue],
    limit: 1,
  );
  return rows.isNotEmpty;
}

