from joblib import Parallel, delayed
import numpy as np
import pandas as pd
from sklearn.model_selection import LeaveOneOut, KFold, LeavePOut
from sklearn import linear_model
from tqdm import tqdm

def get_out_of_set_accuracy(test, train, x, y):
    
    assert(len(test) == 2), 'Test set should contain 2 samples'
    
    model = linear_model.LinearRegression(fit_intercept=True)    
    model.fit(train[x], train[y])
    
    predicted = pd.Series(model.predict(test[x]), index=test.index)
    
    return predicted.idxmax() == test[y].idxmax()


def get_cv2_accuracy(data, x, y, pbar=True):


    splitter = LeavePOut(2)
    n_splits = splitter.get_n_splits(data)
    correct = np.zeros(n_splits)

    splits = enumerate(splitter.split(data))
    
    if pbar:
        splits = tqdm(splits, total=n_splits)
        
    for ix, (train, test) in splits:
        correct[ix] = get_out_of_set_accuracy(data.iloc[test], data.iloc[train], x, y)
        
    return np.mean(correct)


def get_accuracy_and_null(data, x, y, n=250, n_jobs=7):
    
    if type(x) is str:
        x = [x]
    
    empirical_accuracy = get_cv2_accuracy(data, x, y)
    
    null_accuracies = np.zeros(n)
    
    def shuffle_and_get_cv2_accuracy():
        shuffled_data = data.copy()
        shuffled_data[y] = shuffled_data[y].sample(frac=1.).values
        return get_cv2_accuracy(shuffled_data, x, y, pbar=False)

    null_accuracies = Parallel(n_jobs=n_jobs)(delayed(shuffle_and_get_cv2_accuracy)() for i in range(n))
    
    return empirical_accuracy, null_accuracies
