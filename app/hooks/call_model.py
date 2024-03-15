#!/usr/bin/env python3
import argparse
import pickle
import sys
from sklearn.pipeline import Pipeline

CATEGORIES = ['country', 'pop', 'rap', 'rock']

def PredictOnData(pipeline: Pipeline, input_t):
    inp = [input_t]
    predicted = pipeline.predict(inp)
    label = ""
    for _, category in zip(inp, predicted):
        # this loop should only run once
        label = CATEGORIES[category]
    return label

def parseArgs():
    parser = argparse.ArgumentParser(
        prog="tf_idf caller"
    )
    parser.add_argument('--model-name', '-m',
                        default='./backend/model.pkl',
                        type=str)

    parser.add_argument('--song-lyrics', '-s', default="", type=str)

    args = parser.parse_args()
    return args

def main(args):

    if args.song_lyrics == "":
        print("Invalid Input!")
        return

    model = pickle.load(open(args.model_name,'rb'))
    label = PredictOnData(model, args.song_lyrics)
    print(label)
    sys.stdout.flush()



if __name__ == "__main__":
    main(parseArgs())
