import std/parsecsv
import std/strformat
import os

proc get_lyrics(): void =
    var parser: CsvParser
    parser.open("../data/trainp.csv")
    parser.readHeaderRow()

    var rock_i: int = 1
    var metal_i: int = 1
    var pop_i: int = 1
    var indie_i: int = 1
    var rb_i: int = 1
    var folk_i: int = 1
    var electronic_i: int = 1
    var jazz_i: int = 1
    var hiphop_i: int = 1
    var country_i: int = 1

    var count: int = 1
    var fName: string
    var label: string
    var genre: string

    while parser.readRow():
        fName = ""
        label = ""
        genre = parser.rowEntry("genre")

        if genre == "Rock":
            label = "rock"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{rock_i}.txt")
            rock_i += 1
        elif genre == "Metal":
            label = "metal"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{metal_i}.txt")
            metal_i += 1
        elif genre == "Pop":
            label = "pop"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{pop_i}.txt")
            pop_i += 1
        elif genre == "Indie":
            label = "indie"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{indie_i}.txt")
            indie_i += 1
        elif genre == "R&B":
            label = "r&b"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{rb_i}.txt")
            rb_i += 1
        elif genre == "Folk":
            label = "folk"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{folk_i}.txt")
            folk_i += 1
        elif genre == "Electronic":
            label = "electronic"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{electronic_i}.txt")
            electronic_i += 1
        elif genre == "Jazz":
            label = "jazz"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{jazz_i}.txt")
            jazz_i += 1
        elif genre == "Hip-Hop":
            label = "hip-hop"
            fName.add(fmt"../data/train/{label}/")
            fName.add(fmt"file_{hiphop_i}.txt")
            hiphop_i += 1
        elif genre == "Country":
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

let genres = ["rock", "metal", "pop", "indie", "r&b", "folk", "electronic",
        "jazz", "hip-hop", "country"]

for genre in genres:
    if not dirExists(fmt"../data/train/{genre}/"):
        echo fmt"Making ../data/train/{genre} dir"
        createDir(fmt"../data/train/{genre}/")

get_lyrics()
