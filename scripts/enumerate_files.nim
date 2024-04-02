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

enum_files("../data/train/country", "../train-data/country", limit)
enum_files("../data/train/pop", "../train-data/pop", limit)
enum_files("../data/train/hip-hop", "../train-data/hip-hop", limit)
enum_files("../data/train/rock", "../train-data/rock", limit)
enum_files("../data/train/metal", "../train-data/metal", limit)
