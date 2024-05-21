echo -n "Removing existing theme..."
sudo rm -r /usr/share/plymouth/themes/shrek/
echo " Done"
echo -n "Copying new theme..."
sudo rsync -a --exclude ".git" . /usr/share/plymouth/themes/shrek/
echo " Done"
echo -n "Setting new default theme (this might take a while)..."
sudo plymouth-set-default-theme -R shrek
echo " Done"
