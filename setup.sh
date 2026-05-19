#!/usr/bin/env bash
set -euo pipefail

NVHPC_VERSION="26.3"
NVHPC_YEAR="26"
NVHPC_MONTH="3"
NSYS_VERSION="2026.2.1"
NSYS_FULL_VERSION="2026.2.1.210-1"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

log()     { echo -e "${CYAN}==> $*${NC}"; }
success() { echo -e "${GREEN}[ok] $*${NC}"; }
die()     { echo -e "${RED}[error] $*${NC}" >&2; exit 1; }

# ---------------------------------------------------------------------------
log "Installing NVIDIA HPC SDK (nvc++) ${NVHPC_VERSION}"
# ---------------------------------------------------------------------------
curl -fsSL https://developer.download.nvidia.com/hpc-sdk/ubuntu/DEB-GPG-KEY-NVIDIA-HPC-SDK \
  | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-hpcsdk-archive-keyring.gpg

echo 'deb [signed-by=/usr/share/keyrings/nvidia-hpcsdk-archive-keyring.gpg] https://developer.download.nvidia.com/hpc-sdk/ubuntu/amd64 /' \
  | sudo tee /etc/apt/sources.list.d/nvhpc.list > /dev/null

sudo apt-get update -y -q
sudo apt-get install -y -q "nvhpc-${NVHPC_YEAR}-${NVHPC_MONTH}"

export PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/${NVHPC_VERSION}/compilers/bin:${PATH}"
export MANPATH="${MANPATH:-}:/opt/nvidia/hpc_sdk/Linux_x86_64/${NVHPC_VERSION}/compilers/man"
export PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/${NVHPC_VERSION}/comm_libs/mpi/bin:${PATH}"

nvc++ --version || die "nvc++ not found after install"
success "nvc++ installed"

# ---------------------------------------------------------------------------
log "Cloning Kokkos mdspan"
# ---------------------------------------------------------------------------
[[ -d ~/mdspan ]] || git clone https://github.com/kokkos/mdspan.git ~/mdspan
success "mdspan ready at ~/mdspan"

# ---------------------------------------------------------------------------
log "Installing Nsight Systems ${NSYS_VERSION}"
# ---------------------------------------------------------------------------
NSYS_DEB="nsight-systems-${NSYS_VERSION}_${NSYS_FULL_VERSION}_amd64.deb"
wget -q -P /tmp "https://developer.nvidia.com/downloads/assets/tools/secure/nsight-systems/$(echo "${NSYS_VERSION}" | tr '.' '_')/${NSYS_DEB}"
sudo apt-get install -y -q "/tmp/${NSYS_DEB}"
sudo nsys --version || die "nsys not found after install"
success "Nsight Systems installed"

# ---------------------------------------------------------------------------
log "Installing nsys_easy"
# ---------------------------------------------------------------------------
[[ -d ~/nsys_easy ]] || git clone https://github.com/harrism/nsys_easy.git ~/nsys_easy
sudo ln -sf ~/nsys_easy/nsys_easy /usr/bin/nsys_easy
which nsys_easy || die "nsys_easy not on PATH"
success "nsys_easy installed"

echo ""
success "Setup complete."
