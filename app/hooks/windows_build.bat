@echo off

REM Get the current script's directory
set "script_dir=%~dp0"

REM Copy the files relative to the script's directory
copy "%script_dir%\..\..\hooks\call_model.py" "%script_dir%"
copy "%script_dir%\..\..\hooks\model.pkl" "%script_dir%"

REM Install the dependencies from requirements.txt
pip install -r "%script_dir%\..\..\hooks\requirements.txt"
