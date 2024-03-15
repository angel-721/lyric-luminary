#!/bin/sh
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

cp "$script_dir/../../hooks/call_model.py" "$script_dir"
cp "$script_dir/../../hooks/model.pkl" "$script_dir"

pip install -r ../../hooks/requirements.txt


# future reference for myself
# pipreqs ./hooks for pipreqs
