class GoalWeight {
  int id = 0;
  double goalWeight = 0.0;

  GoalWeight(this.id, this.goalWeight);

  GoalWeight.fromJson(Map<String, dynamic> goalWeigthMap){
    id = goalWeigthMap['id'] ?? 0;
    goalWeight = goalWeigthMap['goalWeight'] ?? 0;
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'goalWeight' : goalWeight
    };
  }
}

