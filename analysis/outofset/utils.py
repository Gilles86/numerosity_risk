import contextlib
import joblib
from joblib import Parallel, delayed
import numpy as np
import pandas as pd
from sklearn.model_selection import LeaveOneOut, KFold, LeavePOut
from sklearn import linear_model
from tqdm import tqdm


@contextlib.contextmanager
def tqdm_joblib(tqdm_object):
    """Context manager to patch joblib to report into tqdm progress bar given as argument"""
    class TqdmBatchCompletionCallback(joblib.parallel.BatchCompletionCallBack):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, **kwargs)

        def __call__(self, *args, **kwargs):
            tqdm_object.update(n=self.batch_size)
            return super().__call__(*args, **kwargs)

    old_batch_callback = joblib.parallel.BatchCompletionCallBack
    joblib.parallel.BatchCompletionCallBack = TqdmBatchCompletionCallback
    try:
        yield tqdm_object
    finally:
        joblib.parallel.BatchCompletionCallBack = old_batch_callback
        tqdm_object.close()


def get_out_of_set_accuracy(test, train, x, y):

    intercept_train = np.ones((len(train) ,1 ))
    x_train = np.concatenate((intercept_train, train[x]), 1)

    beta = np.linalg.lstsq(x_train, train[y], rcond=-1)[0]

    intercept_test = np.ones((len(test), 1))
    x_test = np.concatenate((intercept_test, test[x]), 1)
    predicted = x_test @ beta

    return np.argmax(predicted) == np.argmax(test[y])

def get_cv2_accuracy(data, x, y, pbar=True):

    splitter = LeavePOut(2)
    n_splits = splitter.get_n_splits(data)
    correct = np.zeros(n_splits)

    splits = enumerate(splitter.split(data))

    if pbar:
        splits = tqdm(splits, total=n_splits)

    for ix, (train, test) in splits:
        correct[ix] = get_out_of_set_accuracy(
            data.iloc[test], data.iloc[train], x, y)

    return np.mean(correct)


def get_null(data, x, y, n=250, n_jobs=7):

    null_accuracies = np.zeros(n)

    def shuffle_and_get_cv2_accuracy():
        shuffled_data = data.copy()
        shuffled_data[y] = shuffled_data[y].sample(frac=1.).values
        return get_cv2_accuracy(shuffled_data, x, y, pbar=False)

    with tqdm_joblib(tqdm(desc="Null distro", total=n)) as progress_bar:
        null_accuracies = Parallel(n_jobs=n_jobs)(
            delayed(shuffle_and_get_cv2_accuracy)() for i in range(n))

    return null_accuracies
