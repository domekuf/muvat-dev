git submodule init
git submodule update
mkdir $HOME/.muvat/
mkdir $HOME/.muvat/git
cp -r config.d $HOME/.muvat/git/
git config --global include.path $HOME/.muvat/git/config.d/alias
ln -f uninstall.sh $HOME/.muvat/uninstall.sh
ln -f _bashrc $HOME/.muvat/bashrc

## .bashrc START ##
echo "## MUVAT START ##" >> $HOME/.bashrc
echo "#### Don't delete this section. Use \`muvat-uninstall\` instead" >> $HOME/.bashrc
echo "source .muvat/bashrc" >> $HOME/.bashrc
source $HOME/.muvat/bashrc

## JMA START ##
mkdir $HOME/.muvat/jma
ln -f jma/_bashrc $HOME/.muvat/jma/bashrc
echo "source .muvat/jma/bashrc" >> $HOME/.bashrc
source $HOME/.muvat/jma/bashrc
## JMA STOP ##

echo "## MUVAT STOP ##" >> $HOME/.bashrc
## .bashrc STOP ##
