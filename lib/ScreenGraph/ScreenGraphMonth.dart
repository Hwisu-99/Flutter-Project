import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_app/database/dbhelper.dart';
import '../data/dateweight_model.dart';
import 'package:flutter_app/database/shared_preferences_service.dart';
import 'package:flutter_app/color_service.dart';

class GraphChartMonth extends StatefulWidget {
  const GraphChartMonth({Key? key}) : super(key: key);

  @override
  State<GraphChartMonth> createState() => _GraphChartMonthState();
}

class _GraphChartMonthState extends State<GraphChartMonth> {

  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  final DateTime today = DateTime.now();
  double myGoalWeight = 73.0;


  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
      zoomMode: ZoomMode.x,
    );
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: "몸무게",
    );
    getGoalWeightFromSharedPreferences();
    super.initState();
  }

  Future<void> getGoalWeightFromSharedPreferences() async {
    final double savedGoalWeight = SharedPreferencesService.getGoalWeight();
    setState(() {
      myGoalWeight = savedGoalWeight;
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
          palette: [
            ColorService().color1,
          ],
          zoomPanBehavior: _zoomPanBehavior,
          tooltipBehavior: _tooltipBehavior,
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            offset: Offset(-100, 20),
          ),
          primaryYAxis: NumericAxis(
            minimum: myGoalWeight - 2 - (myGoalWeight - myGoalWeight.toInt()),  // 목표 몸무게 - 2
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
            // x축에 표시되는 날짜들의 범위 : 오늘 날짜로부터 +-4일
              minimum: DateTime(today.year,today.month,today.day-15),
              maximum: DateTime(today.year,today.month,today.day+15),
              // today.subtract(Duration(days: -4))
              intervalType: DateTimeIntervalType.days,
              interval: 3
          ),
          series: <ChartSeries>[
            LineSeries<DateWeightData, DateTime>(
              name: '체중 kg',
              enableTooltip: true,
              dataSource: dataList,
              xValueMapper: (DateWeightData data, _) => data.date, // DateFormat('yMMMMd').format(datatime)
              yValueMapper: (DateWeightData data, _) => data.weight,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}
