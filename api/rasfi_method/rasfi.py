import pandas as pd
from typing import List


def get_decision_matrix(
    vars: List[List], criteria: List, alternatives: List
) -> pd.DataFrame:
    decision_matrix = pd.DataFrame(vars, columns=criteria, index=alternatives)
    return decision_matrix


def get_intervals(
    ideal_points: List, anti_ideal_points: List, criteria
) -> pd.DataFrame:
    intervals = pd.DataFrame([ideal_points, anti_ideal_points], columns=criteria)
    return intervals


def transform_value(x, actual_interval, transformed_interval, criteria_type):
    n_1 = transformed_interval[0]
    n_2k = transformed_interval[1]
    if criteria_type == "max":
        ideal_point = actual_interval[0]
        anti_ideal_point = actual_interval[1]
    else:
        ideal_point = actual_interval[1]
        anti_ideal_point = actual_interval[0]
    result = ((n_2k - n_1) / (ideal_point - anti_ideal_point)) * x + (
        ((ideal_point * n_1) - (anti_ideal_point * n_2k))
        / (ideal_point - anti_ideal_point)
    )
    return result


def get_actual_interval(
    s: pd.Series,
    intervals: pd.DataFrame,
    criteria_dict: dict,
    transformed_interval: list,
):
    criteria_type = criteria_dict[s.name]
    actual_interval = intervals.loc[:, s.name]
    return s.apply(
        lambda x: transform_value(
            x, actual_interval, transformed_interval, criteria_type
        )
    )


def get_means(transformation_interval):
    n_1 = transformation_interval[0]
    n_2k = transformation_interval[1]
    arithmetic_mean = (n_1 + n_2k) / 2
    harmonic_mean = 2 / ((1 / n_1) + (1 / n_2k))
    return arithmetic_mean, harmonic_mean


def normalize_matrix(s: pd.Series, criteria_dict: dict, arithmetic_mean, harmonic_mean):
    criteria_type = criteria_dict[s.name]
    if criteria_type == "max":
        return s / (2 * arithmetic_mean)
    else:
        return harmonic_mean / (2 * s)
