# Lyric Luminary
This is a fun project that aims to view lyrics via the lens of a text classification model. I'm experimenting with TF-IDF(and hopefully BERT) to classify songs into a genere via the lyrics of the song. 

## Setup and Install
### Prerequisites
- [Go](https://go.dev/)
- [Wails](https://wails.io/)
- [Python3](https://www.python.org/downloads/)
- [Node](https://nodejs.org/en)

```bash
git clone https://github.com/angel-721/lyric-luminary.git
cd app
wails build
cd build/bin
./lyric-luminary
```
MAKE SURE YOU HAVE A .env with your API keys.
THIS MAY OR MAY NOT WORK ON WINDOWS.

![lyric-lum](https://github.com/angel-721/lyric-luminary/assets/75283919/d1b4cb50-0a9e-40a0-ac2e-97c2e6d5cb1b)

### Training a Model
1) Use the nim scripts to break down this [csv](https://www.kaggle.com/datasets/carlosgdcj/genius-song-lyrics-with-language-information) into txt files
2) Run the main.py with the arg of train ```python main.py train```bash

#### Model specs
- [Tfidf Vectorizer](https://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html)
- [Naive Bayes Classifier](https://scikit-learn.org/stable/modules/naive_bayes.html)
- [Stop words](https://gist.github.com/ethen8181/d57e762f81aa643744c2ffba5688d33a)
