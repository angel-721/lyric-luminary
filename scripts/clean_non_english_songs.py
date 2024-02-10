#!/usr/bin/env python3

import csv

new_file = open("en_lyrics.csv", 'w')
fields = ['tag', 'lyrics']
tags = ['country', 'pop','r&b', 'rap', 'rock', 'acoustic', 'alternative', 'indy']
writer = csv.DictWriter(new_file, fields)
writer.writeheader()

with open('song_lyrics.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)


    for row in reader:
        if row['language_cld3'] == 'en' and row['language_ft'] == 'en':
            if row['tag'] in tags:
                writer.writerow({'tag': row['tag'], 'lyrics': row['lyrics']})

new_file.close()
