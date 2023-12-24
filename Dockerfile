FROM arm32v7/debian:bullseye

RUN <<EOT
  set -ex
  export DEBIAN_FRONTEND="noninteractive"
  apt-get update
  apt-get install -y \
    ccache \
    clang \
    curl \
    git \
    libffi-dev \
    patchelf \
    python3-dev \
    upx
  curl https://pyenv.run | bash
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "\$(pyenv init -)"
  eval "\$(pyenv virtualenv-init -)"
  pyenv install "\${{ inputs.python_version }}"
  pyenv global "\${{ inputs.python_version }}"
  python3 -m venv /opt/lib/nuitka
  source /opt/lib/nuitka/bin/activate
  pip install \
    --extra-index-url https://wheels.eeems.codes/ \
    nuitka
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOT
