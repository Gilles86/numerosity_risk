#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rm -f $DIR/Dockerfile
neurodocker generate docker --base ubuntu --pkg-manager apt --freesurfer version=6.0.0 \
       	--output=$DIR/Dockerfile \
  --install zsh wget git build-essential \
    --miniconda \
      conda_install="python=3.7 pandas matplotlib scikit-learn seaborn ipython" \
      pip_install="nilearn
		nipype
                  pybids
		  niworkflows" \
      create_env="neuro" \
      activate=true \
   --run 'wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true' \
   --run 'conda init zsh' \
   --run 'echo "conda activate neuro" >> ~/.zshrc' \
   --workdir /src
