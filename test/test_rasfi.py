from rasfi_method.main import apply_method
from rasfi_method.method_experiment_utils import remove_worst_alternative
from rasfi_method.model import RasfiResults,RasfiInputs
import pytest
import pandas as pd
import json

def get_inputs():
    inputs = {"criteria" : ["c1", "c2", "c3", "c4", "c5"],
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
    return inputs

def test_should_remove_a6_alternative():
    ranking = {
        "a5": 0.5299303375196233,
        "a1": 0.508095238095238,
        "a4": 0.45597943722943723,
        "a2": 0.45224964985994387,
        "a3": 0.43809523809523815,
        "a6": 0.4372589704896044,
    }
    decision_matrix = {'c1': {'a1': 180, 'a2': 165, 'a3': 160, 'a4': 170, 'a5': 185, 'a6': 167}, 'c2': {'a1': 10.5, 'a2': 9.2, 'a3': 8.8, 'a4': 9.5, 'a5': 10.0, 'a6': 8.9}, 'c3': {'a1': 15.5, 'a2': 16.5, 'a3': 14.0, 'a4': 16.0, 'a5': 14.5, 'a6': 15.1}, 'c4': {'a1': 160, 'a2': 131, 'a3': 125, 'a4': 135, 'a5': 143, 'a6': 140}, 'c5': {'a1': 3.7, 'a2': 5.0, 'a3': 4.5, 'a4': 3.4, 'a5': 4.3, 'a6': 4.1}}
    results = RasfiResults(ranking,decision_matrix)
    decision_matrix_filtered = remove_worst_alternative(results)
    with pytest.raises(KeyError):
        decision_matrix_filtered.loc["a6"]
    assert len(decision_matrix.get("c1")) != len(decision_matrix_filtered.get("c1"))

def test_rasfi_inputs():
    event = get_inputs()
    inputs = RasfiInputs(**event)
    assert type(inputs) == RasfiInputs


def test_rasfi_should_be_consistent_when_removing_alternatives():
    event = get_inputs()
    input = RasfiInputs(**event)
    results = apply_method(input)
    rk_results = []
    while len(results.decision_matrix.get("c1"))>1:
        dm = remove_worst_alternative(results)
        input.decision_matrix = dm
        results = apply_method(
        input)
        rk_results.append(results.ranking)
    for idx,rk in enumerate(rk_results):
        if idx == 0:
            continue
        size = len(rk)
        assert pd.Series(rk_results[idx-1]).nlargest(size).to_dict() == pd.Series(rk).to_dict()

def test_rasfi_should_be_consistent_when_adding_new_alternative():
    inputs = RasfiInputs(**get_inputs())
    results_1 = apply_method(inputs)
    inputs.alternatives.append("a7")
    inputs.vars.append([165,8.9,11,120,3.5])
    results_2 = apply_method(inputs)
    results_2.ranking.pop('a7', None)
    assert results_1.ranking == results_2.ranking