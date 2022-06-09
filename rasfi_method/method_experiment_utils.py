import pandas as pd
from typing import List
from rasfi_method.model import RasfiResults


def remove_worst_alternative(results:RasfiResults):
    rk = pd.Series(results.ranking)
    dm = pd.DataFrame(results.decision_matrix)
    worst_alternative = rk.idxmin()
    return dm.drop(index=worst_alternative)
