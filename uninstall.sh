sed  -i '/MUVAT START/,/MUVAT STOP/d' ../.bashrc

## JMA START ##

## JMA STOP ##

rm -drf $HOME/.muvat
git config --global --unset include.path
