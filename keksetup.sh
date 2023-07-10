#!/bin/bash

# a script to setup python environment in KEK CC
# the python environment will be setup via pyenv
# with GNU GCC/G++ 7.5.0 initilized
#
# B.T.Khai <btkhai-at-post.kek.jp> 2023.07.05

#par1: python version
function PrepareScript () {
    echo "#!/bin/bash"
    echo "cd \$HOME"
    echo "echo 'this script to setup python environment in KEK CC'"
    echo "echo 'the python environment $1 will be setup via pyenv'"
    echo "echo 'script created: $(date)'"

    echo "# Clone pyenv repository & set up python-$1"
    echo "git clone https://github.com/pyenv/pyenv.git ~/.pyenv"
    echo "echo 'export PYENV_ROOT=\"\$HOME/.pyenv\"' >> ~/.bashrc"
    echo "echo 'export PATH=\"\$PYENV_ROOT/bin:\$PATH\"' >> ~/.bashrc"
    echo "echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval \"\$(pyenv init -)\"\\nfi' >> ~/.bashrc"
    echo "pyenv install $1"
    echo "pyenv global $1"
    echo "echo 'The current python version is: ' \$(python --version) "
    echo "echo '                   path is   : ' \$(which python)"


    echo "# Create a virtual environment based on python-$1"
    echo "python -m venv ~/.venvs/py$1"
    echo "source ~/.venvs/py$1/bin/activate"
    echo "# Install pip if needed"
    echo -e "if [ -z $(which pip) ]; then\n\tpython -m ensurepip --upgrade\nfi"
    echo "pip install --upgrade pip"

    
}

function PrintUsage () {
    echo "a script to setup python environment in KEK CC"
    echo "the python environment will be setup via pyenv"
    echo "Usage: ./keksetup.sh <username-on-kekcc> <python-version>"
}

######### Main Program #########

kekuser=$1 #username on KEK CC
pyversion=$2 #desired python version
hostname=login.cc.kek.jp

if [ -z $kekuser ]; then
    echo "no input for username-on-kek. Exit now"
    exit 0
fi

if [ -z $pyversion ]; then
    echo "no input for python version. Exit now"
    exit 0
fi

script=./.python_init.sh
PrepareScript $pyversion > $script
scp $script ${kekuser}@${hostname}:~
cat $script

: '
ssh ${kekuser}@${hostname} <<EOF
    ./$script
    exit
EOF
'	

################################
