# Generated by Neurodocker version 0.6.0
# Timestamp: 2020-01-08 11:16:34 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/kaczmarj/neurodocker

FROM ubuntu

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="en_US.UTF-8" \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'export USER="${USER:=`whoami`}"' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

ENV FREESURFER_HOME="/opt/freesurfer-6.0.0" \
    PATH="/opt/freesurfer-6.0.0/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           libgomp1 \
           libxmu6 \
           libxt6 \
           perl \
           tcsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading FreeSurfer ..." \
    && mkdir -p /opt/freesurfer-6.0.0 \
    && curl -fsSL --retry 5 ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz \
    | tar -xz -C /opt/freesurfer-6.0.0 --strip-components 1 \
         --exclude='freesurfer/average/mult-comp-cor' \
         --exclude='freesurfer/lib/cuda' \
         --exclude='freesurfer/lib/qt' \
         --exclude='freesurfer/subjects/V1_average' \
         --exclude='freesurfer/subjects/bert' \
         --exclude='freesurfer/subjects/cvs_avg35' \
         --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
         --exclude='freesurfer/subjects/fsaverage3' \
         --exclude='freesurfer/subjects/fsaverage4' \
         --exclude='freesurfer/subjects/fsaverage5' \
         --exclude='freesurfer/subjects/fsaverage6' \
         --exclude='freesurfer/subjects/fsaverage_sym' \
         --exclude='freesurfer/trctrain' \
    && sed -i '$isource "/opt/freesurfer-6.0.0/SetUpFreeSurfer.sh"' "$ND_ENTRYPOINT"

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           zsh \
           wget \
           git \
           build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV CONDA_DIR="/opt/miniconda-latest" \
    PATH="/opt/miniconda-latest/bin:$PATH"
RUN export PATH="/opt/miniconda-latest/bin:$PATH" \
    && echo "Downloading Miniconda installer ..." \
    && conda_installer="/tmp/miniconda.sh" \
    && curl -fsSL --retry 5 -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash "$conda_installer" -b -p /opt/miniconda-latest \
    && rm -f "$conda_installer" \
    && conda update -yq -nbase conda \
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && sync && conda clean --all && sync \
    && conda create -y -q --name neuro \
    && conda install -y -q --name neuro \
           "python=3.7" \
           "pandas" \
           "matplotlib" \
           "scikit-learn" \
           "seaborn" \
           "ipython" \
           "tensorflow" \
           "pytables" \
    && sync && conda clean --all && sync \
    && bash -c "source activate neuro \
    &&   pip install --no-cache-dir  \
             "nilearn" \
             "nipype" \
             "pybids" \
             "nistats" \
             "niworkflows" \
             "tensorflow_probability" \
             "https://github.com/Gilles86/hedfpy/archive/refactor_gilles.zip"" \
    && rm -rf ~/.cache/pip/* \
    && sync \
    && sed -i '$isource activate neuro' $ND_ENTRYPOINT

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN conda init zsh

RUN echo "conda activate neuro" >> ~/.zshrc && conda init

WORKDIR /src

COPY ["braincoder", "/braincoder"]

RUN bash -c 'source activate neuro && cd /braincoder && python setup.py develop --no-deps'

COPY ["edf2asc", "/usr/bin/edf2asc"]

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "ubuntu" \
    \n    ], \
    \n    [ \
    \n      "freesurfer", \
    \n      { \
    \n        "version": "6.0.0" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "zsh", \
    \n        "wget", \
    \n        "git", \
    \n        "build-essential" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "miniconda", \
    \n      { \
    \n        "conda_install": [ \
    \n          "python=3.7", \
    \n          "pandas", \
    \n          "matplotlib", \
    \n          "scikit-learn", \
    \n          "seaborn", \
    \n          "ipython", \
    \n          "tensorflow", \
    \n          "pytables" \
    \n        ], \
    \n        "pip_install": [ \
    \n          "nilearn", \
    \n          "nipype", \
    \n          "pybids", \
    \n          "nistats", \
    \n          "niworkflows", \
    \n          "tensorflow_probability", \
    \n          "https://github.com/Gilles86/hedfpy/archive/refactor_gilles.zip" \
    \n        ], \
    \n        "create_env": "neuro", \
    \n        "activate": true \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "conda init zsh" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "echo \"conda activate neuro\" >> ~/.zshrc && conda init" \
    \n    ], \
    \n    [ \
    \n      "workdir", \
    \n      "/src" \
    \n    ], \
    \n    [ \
    \n      "copy", \
    \n      [ \
    \n        "braincoder", \
    \n        "/braincoder" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "source activate neuro && cd /braincoder && python setup.py develop --no-deps" \
    \n    ], \
    \n    [ \
    \n      "copy", \
    \n      [ \
    \n        "edf2asc", \
    \n        "/usr/bin/edf2asc" \
    \n      ] \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json
