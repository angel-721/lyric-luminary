import std/parsecsv
import std/strformat


proc get_lyrics(): void =
  var parser: CsvParser
  parser.open("../en_lyrics.csv")
  parser.readHeaderRow()

  var rap_i: int = 1
  var rock_i: int = 1
  var pop_i: int = 1
  var country_i: int = 1
  var misc_i: int = 1
  var count: int = 1

  var fName: string
  var label: string
  var tag: string

  while parser.readRow():

    fName = ""
    label = ""
    tag = parser.rowEntry("tag")

    if tag == "pop":
      label = "pop"
      fName.add(fmt"./{label}/")
      fName.add(fmt"file_{pop_i}.txt")
      pop_i += 1
    elif tag == "rock":
      label = "rock"
      fName.add(fmt"./{label}/")
      fName.add(fmt"file_{rock_i}.txt")
      rock_i += 1
    elif tag == "misc":
      label = "misc"
      fName.add(fmt"./{label}/")
      fName.add(fmt"file_{misc_i}.txt")
      misc_i += 1
    elif tag == "rap":
      label = "rap"
      fName.add(fmt"./{label}/")
      fName.add(fmt"file_{rap_i}.txt")
      rap_i += 1
    elif tag == "country":
      label = "country"
      fName.add(fmt"./{label}/")
      fName.add(fmt"file_{country_i}.txt")
      country_i += 1
    else:
      echo "Tag not found: ", tag

    writeFile(fName, parser.rowEntry("lyrics"))
    echo "Song: ", count, " Tag: ", tag
    count += 1

  parser.close()


get_lyrics()

