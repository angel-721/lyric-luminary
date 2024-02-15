#!/usr/bin/env python3
import argparse
import pickle
import sys
from scripts.train_tf_idf import *

def parseArgs():
    parser = argparse.ArgumentParser(
        prog="Testing text thingy"
    )
    parser.add_argument('action', default='predict', choices=['predict', 'train',
                                                              'test', 'get-data'])

    parser.add_argument('--model-name', '-m', default='./scripts/model.pkl',
                        type=str)

    parser.add_argument('--load-data', '-d', default=0, type=int)
    parser.add_argument('--song-lyrics', '-s', default="", type=str)

    args = parser.parse_args()
    return args

def main(args):

    if(args.action == 'predict'):
        model = pickle.load(open(args.model_name,'rb'))
        label = PredictOnData(model, args.song_lyrics)
        print(label)
        sys.stdout.flush()

    elif(args.action == 'get-data'):
        GetData(save_data=True)

    elif(args.action == 'train'):
        pipeline = MakePipeline()

        if args.load_data != 0:
            features = pickle.load(open(FEATURES,'rb'))
            labels = pickle.load(open(LABELS,'rb'))
        else:
            features, labels, _, _ = GetData()

        TrainDataAndSave(pipeline, features, labels, modelName=args.model_name)

    elif(args.action == 'test'):
        model = pickle.load(open(args.model_name,'rb'))

        if args.load_data != 0:
            test_features = pickle.load(open(FEATURES_T,'rb'))
            test_labels = pickle.load(open(LABELS_T,'rb'))
        else:
            _, _, test_features, test_labels = GetData()

        TestModel(model, test_features, test_labels)


if __name__ == "__main__":
    main(parseArgs())
