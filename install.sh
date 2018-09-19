git submodule init
git submodule update

mkdir $HOME/.muvat/
mkdir $HOME/.muvat/git

cp -r config.d $HOME/.muvat/git/
git config --global include.path $HOME/.muvat/git/config.d/alias
cp git-completion.bash $HOME/.muvat/git/
# source is done in _allrc/_bashrc

ln -f uninstall.sh $HOME/.muvat/uninstall.sh
ln -f _allrc/_bashrc $HOME/.muvat/bashrc
ln -f _allrc/_vimrc $HOME/.vimrc

## .bashrc START ##
echo "## MUVAT START ##" >> $HOME/.bashrc
echo "#### Don't delete this section. Use \`muvat-uninstall\` instead" >> $HOME/.bashrc
echo "source $HOME/.muvat/bashrc" >> $HOME/.bashrc

## JMA START ##
mkdir $HOME/.muvat/jma
ln -f jma/_bashrc $HOME/.muvat/jma/bashrc
echo "source $HOME/.muvat/jma/bashrc" >> $HOME/.bashrc
## JMA STOP ##

echo "## MUVAT STOP ##" >> $HOME/.bashrc
## .bashrc STOP ##

source $HOME/.bashrc
