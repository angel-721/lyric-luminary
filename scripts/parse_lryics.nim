import std/parsecsv
import std/strformat
import os

proc get_lyrics(): void =
    var parser: CsvParser
    parser.open("../data/en_lyrics.csv")
    parser.readHeaderRow()

    var pop_i: int = 1
    var country_i: int = 1
    var blues_i: int = 1
    var jazz_i: int = 1
    var reggae_i: int = 1
    var rock_i: int = 1
    var hiphop_i: int = 1

    var count: int = 1
    var fName: string
    var label: string
    var genre: string

    while parser.readRow():
        fName = ""
        label = ""
        genre = parser.rowEntry("tag")

        if genre == "rock":
            label = "rock"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{rock_i}.txt")
            rock_i += 1
        elif genre == "blues":
            label = "blues"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{blues_i}.txt")
            blues_i += 1
        elif genre == "pop":
            label = "pop"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{pop_i}.txt")
            pop_i += 1
        elif genre == "reggae":
            label = "reggae"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{reggae_i}.txt")
            reggae_i += 1
        elif genre == "jazz":
            label = "jazz"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{jazz_i}.txt")
            jazz_i += 1
        elif genre == "rap":
            label = "hip-hop"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{hiphop_i}.txt")
            hiphop_i += 1
        elif genre == "country":
            label = "country"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{country_i}.txt")
            country_i += 1
        else:
            echo "Genre not found: ", genre

        writeFile(fName, parser.rowEntry("lyrics"))
        echo "Song: ", count, " genre: ", genre
        count += 1

    parser.close()

let genres = ["pop", "country", "blues", "jazz", "reggae", "rock", "hip-hop"]

for genre in genres:
    if not dirExists(fmt"../data/train/{genre}/"):
        echo fmt"Making ../data/train/{genre} dir"
        createDir(fmt"../data/train/{genre}/")

get_lyrics()
