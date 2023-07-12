import 'package:intl/intl.dart';

class DateWeightData {
  final DateTime date;
  final double? weight;
  DateWeightData({required this.date, this.weight});

  factory DateWeightData.fromMap(Map<String, dynamic> json) => DateWeightData(
    date : DateTime(DateFormat('yyyy-MM-dd').parse(json['date']).year, DateFormat('yyyy-MM-dd').parse(json['date']).month, DateFormat('yyyy-MM-dd').parse(json['date']).day,),
    weight : json['weight'],
  );

  Map<String, dynamic> toMap(){
    return {
      'date' : DateFormat('yyyy-MM-dd').format(date),
      'weight' : weight,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'DateWeightData{date:$date, weight:$weight}';
  }
}




