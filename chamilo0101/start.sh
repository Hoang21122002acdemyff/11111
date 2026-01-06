#!/bin/bash
# Run Face Recognition Attendance System
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_NAME="face_attendance"

# Source conda
for conda_path in "$HOME/miniconda3" "$HOME/anaconda3" "$HOME/miniforge3" "$HOME/mambaforge"; do
    if [ -f "$conda_path/etc/profile.d/conda.sh" ]; then
        source "$conda_path/etc/profile.d/conda.sh"
        break
    fi
done

# Activate environment and run
conda activate $ENV_NAME
cd "$SCRIPT_DIR"
python app_main.py
