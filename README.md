# Lyric Luminary

## CS-4600 Spring 2024 

### Angel Velasquez
This is a fun project that aims to view lyrics via the lens of a text classification model. I'm experimenting with TF-IDF(and hopefully BERT) to classify songs into a genere via the lyrics of the song. 

## Setup and Install
### Prerequisites
- Go
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

![lyric-lum](https://github.com/angel-721/lyric-luminary/assets/75283919/d1b4cb50-0a9e-40a0-ac2e-97c2e6d5cb1b)

#### Checklist
___
 * [x] Prototype a TF-IDF model
 * [x] Create Wails Desktop App for the model
 * [x] Get backend working with [Spotify Web API](https://developer.spotify.com/documentation/web-api)
 * [x] Get backend working with [Genius Web API](https://docs.genius.com/)
 * [x] Make a front end for users to interact with the model(s)
