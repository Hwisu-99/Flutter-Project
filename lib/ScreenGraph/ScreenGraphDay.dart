import 'package:flutter/material.dart';
import 'package:flutter_app/color_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_app/database/dbhelper.dart';
import '../data/dateweight_model.dart';
import 'package:flutter_app/database/shared_preferences_service.dart';
import "dart:math";

class GraphChartDay extends StatefulWidget {
  const GraphChartDay({Key? key}) : super(key: key);


  @override
  State<GraphChartDay> createState() => _GraphChartDayState();
}

class _GraphChartDayState extends State<GraphChartDay> {

  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  final DateTime today = DateTime.now();
  double myGoalWeight = 73.0;
  double myCurrentHeight = 163.0;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
      zoomMode: ZoomMode.x,
    );
    getGoalWeightFromSharedPreferences();
    getCurrentHeightFromSharedPreferences();
    super.initState();
  }

  Future<void> getGoalWeightFromSharedPreferences() async {
    final double savedGoalWeight = SharedPreferencesService.getGoalWeight();
    setState(() {
      myGoalWeight = savedGoalWeight;
    });
  }

  Future<void> getCurrentHeightFromSharedPreferences() async {
    final double savedCurrentHeight = SharedPreferencesService.getCurrentHeight();
    setState(() {
      myCurrentHeight = savedCurrentHeight;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DateWeightData>>(
      future: _getDataFromDatabase(), // Fetch data from the database
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Use the retrieved data to populate the chart
          return _buildChart(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error retrieving data');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<List<DateWeightData>> _getDataFromDatabase() async {
    final dbHelper = DatabaseHelper.instance;
    final dataList = await dbHelper.getChartData(); // Modify this method according to your implementation
    return dataList;
  }

  Widget _buildChart(List<DateWeightData> dataList) {
    return Center(
      child: Container(
        width: 500,
        height: 400,
        child: SfCartesianChart(
          // 그래프릐 전반적인 색상 결정
          palette: [
            ColorService().color1,
          ],
          zoomPanBehavior: _zoomPanBehavior,
          tooltipBehavior: _tooltipBehavior = TooltipBehavior(
            enable: true,
            duration: 2000,
            header: "",
            format: 'point.y',
            builder: (data, point, series, pointIndex, seriesIndex) {
              final DateWeightData chartDate = data;
              final double weightValue = chartDate.weight!;

              //신체질량지수 계사
              //(BMI) = 체중(kg) / [신장(m)] ** 2
              String getBMI() {
                double mHeight = myCurrentHeight/100;
                double bmi = weightValue / pow(mHeight, 2);
                return "BMI : ${double.parse(bmi.toStringAsFixed(2))} \n 몸무게 : $weightValue kg";
              }

              return Container(
                height: 65,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 14.0),
                  child: Text(
                    getBMI(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, ),
                  ),
                ),
              );
            },
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            offset: Offset(-100, 20),
          ),
          primaryYAxis: NumericAxis(
            minimum: myGoalWeight - 2 - (myGoalWeight - myGoalWeight.toInt()), // 목표 몸무게 - 2
            maximum: myGoalWeight + 5 - (myGoalWeight - myGoalWeight.toInt()), // 지금 자신의 몸무게 + 5
            interval: 1,
            // 목표 몸무게 표시
            plotBands: <PlotBand>[
              PlotBand(
                  verticalTextPadding:'-7%',
                  horizontalTextPadding: '3%',
                  text: 'GOAL ${myGoalWeight}KG',
                  textAngle: 0,
                  start: myGoalWeight,
                  end: myGoalWeight,
                  textStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  horizontalTextAlignment: TextAnchor.start,
                  borderColor: Colors.grey,
                  borderWidth: 2,
                  dashArray: const <double>[5, 5]
              )
            ],
          ),
          primaryXAxis: DateTimeAxis(
            autoScrollingMode: AutoScrollingMode.end,
            autoScrollingDelta: 9,
            autoScrollingDeltaType: DateTimeIntervalType.days,
            minimum: DateTime(today.year, today.month, today.day - 10),
            maximum: DateTime(today.year, today.month, today.day + 6),
            intervalType: DateTimeIntervalType.days,
            interval: 1,
            desiredIntervals: 10, // Set a fixed number of intervals
          ),
          series: <ChartSeries>[
            LineSeries<DateWeightData, DateTime>(
              name: '체중 kg',
              enableTooltip: true,
              dataSource: dataList,
              xValueMapper: (DateWeightData data, _) => data.date,
              yValueMapper: (DateWeightData data, _) => data.weight,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              markerSettings: MarkerSettings(isVisible: true),
              // pointColorMapper:
            ),
          ],
        ),
      ),
    );
  }
}

