import "dart:math";

import 'package:taxonomy_method/model/criteria_type.dart';

class Criteria {
  String name;
  String key = "";
  CriteriaType type = CriteriaType.benefit;
  double weight;
  double antiIdealPoint;
  double idealPoint;
  Criteria(
      {required this.name,
      required this.type,
      required this.weight,
      required this.antiIdealPoint,
      required this.idealPoint}) {
    this.key = getRandomString(10);
  }
  Criteria.empty(
      {this.name = "",
      this.antiIdealPoint = 0.0,
      this.idealPoint = 0.0,
      this.weight = 0.0,
      this.type = CriteriaType.benefit});
  Map<String, String> getColumn() {
    return {"title": this.name, "key": this.key};
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": getCriteriaTypeName(type),
        "weight": weight,
        "min_value": antiIdealPoint,
        "max_value": idealPoint
      };
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

CriteriaType getCriteriaType(String criteriaTypeName) {
  if (CriteriaType.benefit.toString().contains(criteriaTypeName)) {
    return CriteriaType.benefit;
  } else {
    return CriteriaType.cost;
  }
}

String getCriteriaTypeName(CriteriaType criteriaType) {
  if (criteriaType == CriteriaType.benefit) {
    return CriteriaType.benefit.toString().split(".")[1];
  } else {
    return CriteriaType.cost.toString().split(".")[1];
  }
}
