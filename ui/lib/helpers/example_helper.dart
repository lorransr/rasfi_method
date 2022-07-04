import 'package:taxonomy_method/model/criteria.dart';
import 'package:taxonomy_method/model/criteria_type.dart';
import 'package:taxonomy_method/model/rasfi_input.dart';

class ExampleHelper {
  RasfiInput rasfiExample() {
    List<Criteria> _criterias = [
      Criteria(
          name: "c1",
          type: CriteriaType.benefit,
          weight: 0.35,
          antiIdealPoint: 120,
          idealPoint: 200),
      Criteria(
          name: "c2",
          type: CriteriaType.benefit,
          weight: 0.35,
          antiIdealPoint: 6,
          idealPoint: 12),
      Criteria(
          name: "c3",
          type: CriteriaType.cost,
          weight: 0.35,
          antiIdealPoint: 20,
          idealPoint: 10),
      Criteria(
          name: "c4",
          type: CriteriaType.cost,
          weight: 0.35,
          antiIdealPoint: 200,
          idealPoint: 100),
      Criteria(
          name: "c5",
          type: CriteriaType.benefit,
          weight: 0.35,
          antiIdealPoint: 2,
          idealPoint: 8),
    ];
    List<List<double>> _vars = [
      [180, 10.5, 15.5, 160, 3.7],
      [165, 9.2, 16.5, 131, 5],
      [160, 8.8, 14, 125, 4.5],
      [170, 9.5, 16, 135, 3.4],
      [185, 10, 14.5, 143, 4.3],
      [167, 8.9, 15.1, 140, 4.1],
    ];
    List<int> _transformationInterval = [1, 6];
    List<String> _alternativesNames = ["a1", "a2", "a3", "a4", "a5", "a6"];

    return RasfiInput(
        criterias: _criterias,
        vars: _vars,
        transformationInterval: _transformationInterval,
        alternativesNames: _alternativesNames);
  }
}


    // event = {"criteria" : ["c1", "c2", "c3", "c4", "c5"],
    // "alternatives" : [
    //     "a1",
    //     "a2",
    //     "a3",
    //     "a4",
    //     "a5",
    //     "a6",
    // ],
    // "vars" : [
    //     [180, 10.5, 15.5, 160, 3.7],
    //     [165, 9.2, 16.5, 131, 5],
    //     [160, 8.8, 14, 125, 4.5],
    //     [170, 9.5, 16, 135, 3.4],
    //     [185, 10, 14.5, 143, 4.3],
    //     [167, 8.9, 15.1, 140, 4.1],
    // ],
    // "weight_list" : [0.35, 0.25, 0.15, 0.15, 0.1],
    // "criteria_type_list" : ["max", "max", "min", "min", "max"],
    // "ideal_points" : [200, 12, 10, 100, 8],
    // "anti_ideal_points" : [120, 6, 20, 200, 2],
    // "transformation_interval" : [1, 6]
    // }