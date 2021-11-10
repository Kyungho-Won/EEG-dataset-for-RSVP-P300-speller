import statsmodels.api as sm
import numpy as np
from sklearn.linear_model import LinearRegression

def get_stats(dat, x_columns, y):
    x = dat[:, x_columns]
    results = sm.OLS(y, x).fit()
    return results

def stepwise_linear_model(dat, init_x_column, y_train, p_val):
    x_column = init_x_column
    
    while True:
        results_stats = get_stats(dat, x_column, y_train)
        if np.max(results_stats.pvalues) <= p_val:
            break
        else:
            backward_elim = np.argmax(results_stats.pvalues)
            x_column = np.delete(x_column, backward_elim)

    return x_column, results_stats
