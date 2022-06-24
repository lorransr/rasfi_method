import 'package:taxonomy_method/model/criteria.dart';
import 'package:taxonomy_method/model/criteria_type.dart';
import 'package:taxonomy_method/model/taxonomy_input.dart';

class ExampleHelper {
  TaxonomyInput carExample() {
    List<Criteria> _criterias = [
      Criteria("custo", CriteriaType.cost),
      Criteria("mala", CriteriaType.benefit),
      Criteria("seguranca", CriteriaType.benefit),
      Criteria("confort", CriteriaType.benefit),
      Criteria("tempo_de_entrega", CriteriaType.cost),
    ];
    List<List<double>> _alternatives = [
      [40, 380, 11, 9, 22],
      [52, 590, 13, 9, 10],
      [68, 710, 15, 13, 25],
      [92, 900, 18, 15, 2],
    ];

    List<String> _alternativesNames = ["ka", "onix", "prisma", "eco_esporte"];
    return TaxonomyInput(_criterias, _alternatives, _alternativesNames);
  }
  RasfiInput rasfiExample(){
    List<Criteria> _criterias = [
      Criteria("c1",CriteriaType.benefit),
      Criteria("c2",CriteriaType.benefit),
      Criteria("c3",CriteriaType.cost),
      Criteria("c4",CriteriaType.cost),
      Criteria("c5",CriteriaType.benefit),
      ];
    List<List<double>> _vars = 
    [
        [180, 10.5, 15.5, 160, 3.7],
        [165, 9.2, 16.5, 131, 5],
        [160, 8.8, 14, 125, 4.5],
        [170, 9.5, 16, 135, 3.4],
        [185, 10, 14.5, 143, 4.3],
        [167, 8.9, 15.1, 140, 4.1],
    ];
    List<double> _weighList =  [0.35, 0.25, 0.15, 0.15, 0.1];
    List<double> _idealPoints = [200, 12, 10, 100, 8];
    List<double> _antiIdealPoints = [120, 6, 20, 200, 2];
    List<int> _transformationInterval =[1, 6];
    List<String> _alternativesNames = ["a1","a2","a3","a4","a5","a6"];

    
    return RasfiInput(criterias: _criterias,vars: _vars,weighList: _weighList,idealPoints: _idealPoints,antiIdealPoints: _antiIdealPoints,transformationInterval: _transformationInterval,alternativesNames: _alternativesNames);
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