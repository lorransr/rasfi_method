import pandas as pd
from typing import List, Dict
import json

from rasfi_method.model import RasfiInputs, RasfiResults
from rasfi_method.rasfi import (
    get_decision_matrix,
    get_intervals,
    get_means,
    get_actual_interval,
    normalize_matrix,
)


def apply_method(
    inputs:RasfiInputs
) -> RasfiResults:
    decision_matrix = inputs.decision_matrix
    weights = dict(zip(inputs.criteria, inputs.weight_list))
    criteria_dict = dict(zip(inputs.criteria, inputs.criteria_type_list))
    if type(decision_matrix) != type(None):
      inputs.alternatives = list(decision_matrix.columns)
    else:
      decision_matrix = get_decision_matrix(inputs.vars, inputs.criteria, inputs.alternatives)
    # etapa 1
    intervals = get_intervals(inputs.ideal_points, inputs.anti_ideal_points, inputs.criteria)
    # etapa 2
    decision_matrix_transformed = decision_matrix.apply(
        lambda s: get_actual_interval(
            s, intervals, criteria_dict, inputs.transformation_interval
        )
    )
    # etapa 3
    arithmetic_mean, harmonic_mean = get_means(inputs.transformation_interval)
    # etapa 4
    decision_matrix_normalized = decision_matrix_transformed.apply(
        lambda s: normalize_matrix(s, criteria_dict, arithmetic_mean, harmonic_mean)
    )
    # etapa 5
    results = (
        (decision_matrix_normalized * weights).sum(axis=1).sort_values(ascending=False)
    )
    return RasfiResults(
        results.to_dict(),
        decision_matrix.to_dict(),
        decision_matrix_transformed.to_dict(),
        decision_matrix_normalized.to_dict(),
        harmonic_mean,
        arithmetic_mean,
    )


if __name__ == "__main__":
    event = {"criteria" : ["c1", "c2", "c3", "c4", "c5"],
    "alternatives" : [
        "a1",
        "a2",
        "a3",
        "a4",
        "a5",
        "a6",
    ],
    "vars" : [
        [180, 10.5, 15.5, 160, 3.7],
        [165, 9.2, 16.5, 131, 5],
        [160, 8.8, 14, 125, 4.5],
        [170, 9.5, 16, 135, 3.4],
        [185, 10, 14.5, 143, 4.3],
        [167, 8.9, 15.1, 140, 4.1],
    ],
    "weight_list" : [0.35, 0.25, 0.15, 0.15, 0.1],
    "criteria_type_list" : ["max", "max", "min", "min", "max"],
    "ideal_points" : [200, 12, 10, 100, 8],
    "anti_ideal_points" : [120, 6, 20, 200, 2],
    "transformation_interval" : [1, 6]
    }
    inputs = RasfiInputs(**event)
    results = apply_method(
        inputs
    )
    print(json.dumps(results.__dict__))
