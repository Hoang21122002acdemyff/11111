#!/bin/bash
# ==============================================
# SETUP SCRIPT - Face Recognition Attendance
# Tương thích: macOS, Linux (Ubuntu/Debian/Fedora/Arch)
# Chạy: bash setup.sh
# ==============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_NAME="face_attendance"

print_header() {
    echo ""
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_success "Detected: macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        # Detect Linux distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
            print_success "Detected: Linux ($DISTRO)"
        else
            DISTRO="unknown"
            print_warning "Unknown Linux distribution"
        fi
    else
        print_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Install system dependencies
install_system_deps() {
    print_header "Installing System Dependencies"
    
    if [[ "$OS" == "macos" ]]; then
        # Check if Homebrew is installed
        if ! command -v brew &> /dev/null; then
            print_warning "Homebrew not found. Installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        print_success "Homebrew is installed"
        
        # Install dependencies via Homebrew
        brew install cmake || true
        print_success "CMake installed"
        
    elif [[ "$OS" == "linux" ]]; then
        case "$DISTRO" in
            ubuntu|debian|linuxmint|pop)
                print_success "Using apt package manager"
                sudo apt-get update
                sudo apt-get install -y \
                    build-essential cmake \
                    libx11-dev libxcb1 libxcb-xinerama0 libxcb-cursor0 \
                    libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 \
                    libxkbcommon-x11-0 libgl1-mesa-glx libglib2.0-0 \
                    libsm6 libxext6 libxrender1 libfontconfig1 \
                    libdbus-1-3 libegl1 libxkbcommon0 libopenblas-dev liblapack-dev \
                    v4l-utils libxcb-util1 libxcb-glx0 \
                    python3-dev python3-pip
                ;;
            fedora|centos|rhel)
                print_success "Using dnf/yum package manager"
                sudo dnf install -y \
                    gcc gcc-c++ cmake \
                    libX11-devel libxcb libxkbcommon-x11 \
                    mesa-libGL glib2 \
                    openblas-devel lapack-devel \
                    python3-devel python3-pip
                ;;
            arch|manjaro)
                print_success "Using pacman package manager"
                sudo pacman -Syu --noconfirm \
                    base-devel cmake \
                    libx11 libxcb libxkbcommon-x11 \
                    mesa glib2 \
                    openblas lapack \
                    python python-pip
                ;;
            *)
                print_warning "Unknown distribution. Please install dependencies manually."
                print_warning "Required: cmake, libx11, libxcb, openblas, lapack, python3-dev"
                ;;
        esac
        print_success "System dependencies installed"
    fi
}

# Check and install Conda (using Miniforge - no ToS required!)
install_conda() {
    print_header "Checking Conda Installation"
    
    # Check common Conda installation paths (prefer miniforge)
    CONDA_PATHS=(
        "$HOME/miniforge3/bin/conda"
        "$HOME/mambaforge/bin/conda"
        "$HOME/miniconda3/bin/conda"
        "$HOME/anaconda3/bin/conda"
        "/opt/conda/bin/conda"
    )
    
    for path in "${CONDA_PATHS[@]}"; do
        if [ -f "$path" ]; then
            print_success "Found Conda at: $path"
            export PATH="$(dirname $path):$PATH"
            source "$(dirname $path)/../etc/profile.d/conda.sh"
            return 0
        fi
    done
    
    # Check if conda command exists
    if command -v conda &> /dev/null; then
        print_success "Conda is already installed"
        return 0
    fi
    
    # Install Miniforge (uses conda-forge only - NO ToS required!)
    print_warning "Conda not found. Installing Miniforge (no ToS required)..."
    
    MINIFORGE_DIR="$HOME/miniforge3"
    
    if [[ "$OS" == "macos" ]]; then
        if [[ $(uname -m) == "arm64" ]]; then
            MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh"
        else
            MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh"
        fi
    else
        if [[ $(uname -m) == "aarch64" ]]; then
            MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh"
        else
            MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
        fi
    fi
    
    INSTALLER="/tmp/miniforge_installer.sh"
    
    print_success "Downloading Miniforge from: $MINIFORGE_URL"
    curl -fsSL "$MINIFORGE_URL" -o "$INSTALLER"
    
    print_success "Installing Miniforge to: $MINIFORGE_DIR"
    bash "$INSTALLER" -b -p "$MINIFORGE_DIR"
    rm "$INSTALLER"
    
    # Add to PATH and initialize
    export PATH="$MINIFORGE_DIR/bin:$PATH"
    source "$MINIFORGE_DIR/etc/profile.d/conda.sh"
    
    # Configure conda
    conda config --set auto_activate_base false
    
    # Initialize conda for shell
    conda init bash 2>/dev/null || true
    conda init zsh 2>/dev/null || true
    
    print_success "Miniforge installed successfully!"
    print_warning "Please restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
}

# Setup Conda environment
setup_environment() {
    print_header "Setting up Conda Environment"
    
    # Source conda
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        source "$HOME/miniconda3/etc/profile.d/conda.sh"
    elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        source "$HOME/anaconda3/etc/profile.d/conda.sh"
    elif [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        source "$HOME/miniforge3/etc/profile.d/conda.sh"
    fi
    
    # Use only conda-forge channel (no ToS required!)
    conda config --remove channels defaults 2>/dev/null || true
    conda config --add channels conda-forge 2>/dev/null || true
    conda config --set channel_priority strict 2>/dev/null || true
    
    # Check if environment exists
    if conda env list | grep -q "^${ENV_NAME} "; then
        print_warning "Environment '$ENV_NAME' already exists"
        read -p "Do you want to recreate it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_success "Removing old environment..."
            conda env remove -n $ENV_NAME -y
        else
            print_success "Using existing environment"
            return 0
        fi
    fi
    
    # Create environment from yml file
    print_success "Creating Conda environment: $ENV_NAME"
    export CONDA_ALWAYS_YES="true"
    
    # Create environment with dlib from conda-forge (avoid build issues)
    print_success "Installing Python 3.10 and dlib from conda-forge..."
    conda create -n $ENV_NAME -c conda-forge --override-channels python=3.10 pip dlib -y
    
    # Activate and install pip packages
    print_success "Installing Python packages via pip..."
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate $ENV_NAME
    
    pip install --upgrade pip
    pip install numpy==1.26.4 pandas==2.1.4 opencv-python-headless==4.9.0.80 \
                PySide6==6.6.1 mediapipe==0.10.9 \
                face_recognition==1.3.0 openpyxl==3.1.2
    
    print_success "Environment '$ENV_NAME' created successfully!"
}

# Create necessary directories
create_directories() {
    print_header "Creating Directories"
    
    mkdir -p "$SCRIPT_DIR/known_faces"
    mkdir -p "$SCRIPT_DIR/attendance_records"
    mkdir -p "$SCRIPT_DIR/Logo"
    
    print_success "Created: known_faces/"
    print_success "Created: attendance_records/"
    print_success "Created: Logo/"
}

# Create run script
create_run_script() {
    print_header "Creating Run Script"
    
    cat > "$SCRIPT_DIR/start.sh" << 'RUNEOF'
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
RUNEOF
    
    chmod +x "$SCRIPT_DIR/start.sh"
    print_success "Created: start.sh"
}

# Main installation
main() {
    print_header "Face Recognition Attendance - Setup"
    echo "This script will install all dependencies and setup the environment."
    echo ""
    
    cd "$SCRIPT_DIR"
    
    # Step 1: Detect OS
    detect_os
    
    # Step 2: Install system dependencies
    install_system_deps
    
    # Step 3: Install Conda
    install_conda
    
    # Step 4: Setup environment
    setup_environment
    
    # Step 5: Create directories
    create_directories
    
    # Step 6: Create run script
    create_run_script
    
    print_header "Setup Complete!"
    echo -e "${GREEN}To run the application:${NC}"
    echo ""
    echo -e "  ${YELLOW}Option 1:${NC} bash start.sh"
    echo ""
    echo -e "  ${YELLOW}Option 2:${NC}"
    echo "    conda activate $ENV_NAME"
    echo "    python app_main.py"
    echo ""
    echo -e "${BLUE}Note: If this is a fresh Conda install, restart your terminal first!${NC}"
    echo ""
}

# Run main
main "$@"
