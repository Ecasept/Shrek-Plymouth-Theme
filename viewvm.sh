echo -n "Removing existing theme..."
rm -r ~/VM\ Shared/shrek/
echo " Done"
echo -n "Copying new theme..."
rsync -a --exclude ".git" . ~/VM\ Shared/shrek/
echo " Done"
touch ~/VM\ Shared/touch.txt
echo "Updated touch file"
