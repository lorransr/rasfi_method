from dataclasses import dataclass
import pandas as pd
from typing import List,Optional,TypeVar
from pydantic import BaseModel

@dataclass
class RasfiResults:
    ranking: dict = None
    decision_matrix: dict = None
    transformed_decision_matrix: dict = None
    normalized_decision_matrix: dict = None
    harmonic_mean: float = None
    arithmetic_mean: float = None

class RasfiInputs(BaseModel):
    class Config:
        arbitrary_types_allowed = True
    criteria: List
    weight_list: List[float]
    criteria_type_list: List[str]
    ideal_points: List
    anti_ideal_points: List
    transformation_interval: List
    alternatives: Optional[List] = None
    vars: Optional[List] = None
    decision_matrix: Optional[pd.DataFrame] = None