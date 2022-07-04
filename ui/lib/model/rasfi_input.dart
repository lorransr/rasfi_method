import 'package:taxonomy_method/model/criteria.dart';

class RasfiInput {
  List<Criteria> criterias;
  List<String>? criteriaList;
  List<String>? criteriaTypeList;
  List<double>? weightList;
  List<double>? idealPoints;
  List<double>? antiIdealPoints;
  List<int> transformationInterval;
  List<List<double>> vars;
  List<String> alternativesNames;
  RasfiInput(
      {required this.criterias,
      required this.transformationInterval,
      required this.alternativesNames,
      required this.vars}) {
    this.criteriaList = criterias.map((e) => e.name).toList();
    this.criteriaTypeList =
        criterias.map((e) => getCriteriaTypeName(e.type)).toList();
    this.weightList = criterias.map((e) => e.weight).toList();
    this.idealPoints = criterias.map((e) => e.idealPoint).toList();
    this.antiIdealPoints = criterias.map((e) => e.antiIdealPoint).toList();
  }

  Map<String, dynamic> toJson() => {
        'criteria': criteriaList,
        'weight_list': weightList,
        'criteria_type_list': criteriaTypeList,
        'ideal_points': idealPoints,
        'anti_ideal_points': antiIdealPoints,
        'transformation_interval': transformationInterval,
        'alternatives': alternativesNames,
        'vars': vars,
      };
}
// class RasfiInputs(BaseModel):
//     class Config:
//         arbitrary_types_allowed = True
//     criteria: List
//     weight_list: List[float]
//     criteria_type_list: List[str]
//     ideal_points: List
//     anti_ideal_points: List
//     transformation_interval: List
//     alternatives: Optional[List] = None
//     vars: Optional[List] = None
//     decision_matrix: Optional[pd.DataFrame] = None