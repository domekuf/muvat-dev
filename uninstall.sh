sed  -i '/MUVAT START/,/MUVAT STOP/d' $HOME/.bashrc

## JMA START ##

## JMA STOP ##

rm -drf $HOME/.muvat
rm -rf $HOME/.vimrc
git config --global --unset include.path
