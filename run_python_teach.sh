#!/bin/bash
#SBATCH --job-name=test_2770               # Job name
#SBATCH --output=code_gpu-%j.out      # Output file
#SBATCH --error=code_gpu-%j.err       # Error file
#SBATCH --nodes=1   
#SBATCH --ntasks-per-node=1               # One task per node
#SBATCH --cpus-per-task=1
#SBATCH --cluster=teach                     # gpu | teach
#SBATCH --gres=gpu:1                      # Asking for 1 GPU
#SBATCH --partition=gpu                  # Partition l40s | gpu
#SBATCH --mem=128GB                       # Requested Memory RAM
#SBATCH --time=16:00:00                   # Max Requested Time hh:mm:ss
#SBATCH --mail-user=nem177@pitt.edu       # Pitt email for notifications
#SBATCH --mail-type=END,FAIL              # Send an email when finished or if it is an issue

# Script was adapted from Student Nayeli Silva's code

# Paths
#SHARED_FOLDER="/ihome/nllerena/nem177/cs2770/"
SHARED_FOLDER="/ihome/nllerena/nem177/tutorial_pitt_CRC/"
INPUT_FILE="${SHARED_FOLDER}/Pitt_CRC_example.py"

# Clean previous modules
module purge

# Add required modules
module load cuda/12.1
module load python/3.11

# Ensure that pip folder is in our PATH
export PATH=$HOME/.local/bin:$PATH
unset LD_LIBRARY_PATH

# Install Packages
pip3 install Pillow

# Output some information
echo "Executing in node: $(hostname)"
echo "Date: $(date)"
echo "Working Directory: $(pwd)"
echo "GPU information:"
nvidia-smi

# Double check existence of notebook
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Can not find input file: $INPUT_FILE"
    exit 1
fi

# Ejecutar python code
echo "Initializing code..."
echo "Input: $INPUT_FILE"

python3 "$INPUT_FILE"

# Ensuring that execution is correct
if [ $? -eq 0 ]; then
    echo "Code executed correctly!"
else
    echo "Error while executing code."
    exit 1
fi

echo "Job finished on: $(date)"
