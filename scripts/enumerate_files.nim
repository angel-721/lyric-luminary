import os
import std/strformat
import std/parseopt
import strutils

proc enum_files(oldDirName: string, newDirName: string, limit: int): void =
  var i: int = 1
  var newFileName: string;

  for file in walkDir(oldDirName):
    newFileName = newDirName
    newFileName.add(fmt"/file_{i}.txt")
    copyFile(file.path, newFileName)

    i+=1
    if i > limit:
      break


var p = initOptParser()
var limit: int = parseInt(p.cmdLineRest)

enum_files("../data/country", "../train-data/country", limit)
enum_files("../data/pop", "../train-data/pop", limit)
enum_files("../data/rap", "../train-data/rap", limit)
enum_files("../data/rock", "../train-data/rock", limit)
