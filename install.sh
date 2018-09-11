git submodule init
git submodule update
mkdir $HOME/.muvat/
mkdir $HOME/.muvat/git
cp -r config.d $HOME/.muvat/git/
git config --global include.path $HOME/.muvat/git/config.d/alias

## JMA START ##
mkdir $HOME/.muvat/jma
ln -f jma/_bashrc $HOME/.muvat/jma/bashrc
## JMA STOP ##
