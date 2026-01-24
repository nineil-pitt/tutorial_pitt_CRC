#!/bin/bash
#SBATCH --job-name=test_2770               # Job name
#SBATCH --output=notebook_gpu-%j.out      # Output file
#SBATCH --error=notebook_gpu-%j.err       # Error file
#SBATCH --nodes=1   
#SBATCH --ntasks-per-node=1               # One task per node
#SBATCH --cpus-per-task=1
#SBATCH --cluster=gpu 
#SBATCH --gres=gpu:1                      # Asking for 1 GPU
#SBATCH --partition=l40s                  # Partition L40S
#SBATCH --constraint=l40s,48g,intel       # GPU L40S con 48GB
#SBATCH --mem=128GB                       # Requested Memory RAM
#SBATCH --time=16:00:00                   # Max Requested Time hh:mm:ss
#SBATCH --mail-user=nem177@pitt.edu       # Pitt email for notifications
#SBATCH --mail-type=END,FAIL              # Send an email when finished or if it is an issue

# Script was adapted from Student Nayeli Silva's code

# Paths
SHARED_FOLDER="/ihome/nllerena/nem177/cs2770/"
INPUT_NOTEBOOK="${SHARED_FOLDER}/Pitt_CRC_example.ipynb"
OUTPUT_NOTEBOOK="${SHARED_FOLDER}/out_Pitt_CRC_example.ipynb"

# Clean previous modules
module purge

# Add required modules
module load cuda/12.1
module load python/3.11

# Ensure that pip folder is in our PATH
export PATH=$HOME/.local/bin:$PATH
unset LD_LIBRARY_PATH

# Verify that papermill is installed, if not, install it
if ! command -v papermill &> /dev/null; then
    echo "Can not find Papermill. Installing..."
    pip install --user papermill
    echo "Papermill installed succesfully!"
fi

# Output some information
echo "Executing in node: $(hostname)"
echo "Date: $(date)"
echo "Working Directory: $(pwd)"
echo "GPU information:"
nvidia-smi

# Double check existence of notebook
if [ ! -f "$INPUT_NOTEBOOK" ]; then
    echo "Error: Can not find input file: $INPUT_NOTEBOOK"
    exit 1
fi

# Ejecutar notebook con Papermill
echo "Initializing notebook..."
echo "Input: $INPUT_NOTEBOOK"
echo "Output: $OUTPUT_NOTEBOOK"

papermill "$INPUT_NOTEBOOK" "$OUTPUT_NOTEBOOK" \
    --log-output \
    --report-mode

# Ensuring that execution is correct
if [ $? -eq 0 ]; then
    echo "Notebook executed correctly!"
    echo "Output File: $OUTPUT_NOTEBOOK"
else
    echo "Error while executing notebook."
    exit 1
fi

echo "Job finished on: $(date)"
