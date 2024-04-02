#!/usr/bin/env python3

import argparse
import pickle
import numpy as np

from sklearn.feature_extraction.text import TfidfTransformer, CountVectorizer
from sklearn.utils import Bunch
from sklearn.datasets import load_files
from sklearn.pipeline import Pipeline
# from sklearn.linear_model import SGDClassifier
from sklearn.naive_bayes import ComplementNB
from  sklearn.model_selection import GridSearchCV, train_test_split



if __name__ != "__main__":
    DIRNAME = "./train-data"

    FEATURES = "./train-data/features.pkl"
    LABELS = "./train-data/labels.pkl"

    FEATURES_T = "./train-data/test_features.pkl"
    LABELS_T = "./train-data/test_labels.pkl"

    DATA = "./train-data/data.pkl"

    STOPWORDS = "./train-data/stop-words.pkl"

else:
    DIRNAME = "../train-data"

    FEATURES = "../train-data/features.pkl"
    LABELS = "../train-data/labels.pkl"

    FEATURES_T = "../train-data/test_features.pkl"
    LABELS_T = "../train-data/test_labels.pkl"

    DATA = "../train-data/data.pkl"

    STOPWORDS = "../train-data/stop-words.pkl"

CATEGORIES = ['country', 'hip-hop', 'metal', 'pop', 'rock']


def GetData(dir_name: str = DIRNAME, save_data:bool = False):
    DATA = load_files(DIRNAME, categories=CATEGORIES)
    XTRAIN, XTEST, YTRAIN, YTEST = train_test_split(DATA.data, DATA.target,
                                                train_size=0.8, test_size=0.2)

    if save_data:
        pickle.dump(XTRAIN, file=open(FEATURES, 'wb'))
        pickle.dump(YTRAIN, file=open(LABELS, 'wb'))

        pickle.dump(XTEST, file=open(FEATURES_T, 'wb'))
        pickle.dump(YTEST, file=open(LABELS_T, 'wb'))

    print(DATA.target_names)


    return XTRAIN, YTRAIN, XTEST, YTEST



TESTSONG = """
Two bit Billy was the coolest cat I ever saw
Didn't want no piece of the pie he had to take it all
With his guitar slung low, hanging right above the knees

He made the biggest scene
He made the ladies scream
He had a state fair smile if you know what I mean

[Chorus]
He was livin' for the minute
Living his life from day to day
If you want it, then take it

He said:
That's the rules
If you wanna play

Magazines covers always shooting for Billy's face
He score of his ladies chalked up on his guitar case
He was a bad ass rocking, baby, always rolling out the sounds
Like some freight train coming
Did a six string strut
And just tied it down past all the crowd

[Chorus]

Better stop and get out, CC
C'mon, c'mon, c'mon!

"""

def MakePipeline() -> Pipeline:
    stop_list = pickle.load(open(STOPWORDS, 'rb'))
    text_clf = Pipeline([
        ('vect', CountVectorizer(stop_words=stop_list)),
        ('tfidf', TfidfTransformer()),
        ('clf', ComplementNB(alpha=0.1))])
    return text_clf

def TrainDataAndSave(pipeline: Pipeline, features: str, labels: str, modelName: str = "model.pkl") -> None:
    parameters = {
     'vect__ngram_range': [(1, 1), (1, 2)],
     'tfidf__use_idf': (True, False),
     'clf__alpha': (1e-2, 1e-3,  1, 2),
    }

    grid_search_pipeline = GridSearchCV(pipeline, parameters, cv=5, n_jobs=-1)

    # pipeline.fit(TRAININGDATA.data, TRAININGDATA.target)
    final_pipeline = grid_search_pipeline.fit(features, labels)
    pickle.dump(final_pipeline, file=open(modelName, 'wb'))


def TestModel(pipeline: Pipeline, features: str, labels: str) -> None:
    predicted = pipeline.predict(features)
    results = np.mean(predicted == labels)
    print(results)

def PredictOnData(pipeline: Pipeline, input_t):
    inp = [input_t]
    predicted = pipeline.predict(inp)
    label = ""
    for _, category in zip(inp, predicted):
        # this loop should only run once
        label = CATEGORIES[category]
    return label
