import 'package:taxonomy_method/model/criteria.dart';

class TaxonomyInput {
  List<Criteria> criterias;
  List<List<double>> alternatives;
  List<String> alternativesNames;
  TaxonomyInput(this.criterias, this.alternatives, this.alternativesNames);

  Map<String, dynamic> toJson() => {
        'criterias': criterias,
        'alternatives': alternatives,
        'alternatives_names': alternativesNames
      };
}

class RasfiInput {
  List<Criteria> criterias;
  List<String>? criteriaList;
  List<double> weighList;
  List<String>? criteriaTypeList;
  List<double> idealPoints;
  List<double> antiIdealPoints;
  List<int> transformationInterval;
  List<List<double>> vars;
  List<String> alternativesNames;
  RasfiInput(
      {required this.criterias,
      required this.weighList,
      required this.idealPoints,
      required this.antiIdealPoints,
      required this.transformationInterval,
      required this.alternativesNames,
      required this.vars}) {
    this.criteriaList = criterias.map((e) => e.name).toList();
    this.criteriaTypeList =
        criterias.map((e) => getCriteriaTypeName(e.type)).toList();
  }

  Map<String, dynamic> toJson() => {
        'criteria': criteriaList,
        'weight_list': weighList,
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