# Get nvc++
cd ~
curl https://developer.download.nvidia.com/hpc-sdk/ubuntu/DEB-GPG-KEY-NVIDIA-HPC-SDK | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-hpcsdk-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/nvidia-hpcsdk-archive-keyring.gpg] https://developer.download.nvidia.com/hpc-sdk/ubuntu/amd64 /' | sudo tee /etc/apt/sources.list.d/nvhpc.list
sudo apt-get update -y
sudo apt-get install -y nvhpc-26-3
export PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/compilers/bin:$PATH
export MANPATH=$MANPATH:/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/compilers/man
export PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/mpi/bin:$PATH
nvc++ --version

# Get mdspan from kokkas for c++20
cd ~
git clone https://github.com/kokkos/mdspan.git

# Get nsys
cd ~
wget https://developer.nvidia.com/downloads/assets/tools/secure/nsight-systems/2026_2/nsight-systems-2026.2.1_2026.2.1.210-1_amd64.deb
sudo apt install ./nsight-systems-2026.2.1_2026.2.1.210-1_amd64.deb
sudo nsys --version 

# Get nsys_easy
git clone https://github.com/harrism/nsys_easy.git
sudo ln -s ~/nsys_easy/nsys_easy /usr/bin/
which nsys_easy

echo 'SETUP COMPLETE'