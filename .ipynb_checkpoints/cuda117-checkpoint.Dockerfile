FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel
ENV TZ=Asia/Seoul, DEBIAN_FRONTEND=noninteractive, CUDA=/usr/local/cuda, LD_LIBRARY_PATH=$CUDA/include:$CUDA/lib64 WORK=/workspace/work, STORAGE=/workspace/storage, PATH=/root/.cargo/bin:$PATH

RUN apt-get update && apt-get upgrade -y && apt install -y \
    fonts-dejavu unixodbc-dev libcurl4-openssl-dev libzmq3-dev gdebi-core \
    vim gcc build-essential pkg-config openssl curl wget expect cmake \
    libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libx265-dev \
    libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev libtbb2 libtbb-dev libdc1394-22-dev \
    software-properties-common dirmngr && \
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    add-apt-repository ppa:c2d4u.team/c2d4u4.0+ && \
    apt install -y r-base-dev && \
    pip install jupyter tensorboard matplotlib scikit-learn ipywidgets torchinfo pandas sympy seaborn && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    jupyter notebook --generate-config && \
    echo "c.ServerApp.password = u\"argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$E5kTv3MH5/G1ewc47C2SbQ\$UGVYYkXpDMbxIv02ULHMFU5Y2Yulh2haCOlNFm9ZMAI\" \nc.ServerApp.ip = '0.0.0.0' \nc.ServerApp.notebook_dir = '/workspace' \nc.ServerApp.allow_root = True \nc.ServerApp.open_browser = False \nc.ServerApp.port = 8888" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "local({\n    r <- getOption(\"repos\")\n    r[\"CRAN\"] <- \"https://cran.yu.ac.kr/\"\n    options(repos=r)\n})" > /usr/lib/R/etc/Rprofile.site && \
    echo "install.packages(c(\"tidyverse\", \"IRkernel\"));IRkernel::installspec()" > test.R && \
    Rscript test.R && \
    rm test.R

WORKDIR /workspace/work
CMD jupyter notebook > /root/jupyter.log
