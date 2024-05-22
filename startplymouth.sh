HOME_DIR=/home/guy

sudo cp -r $HOME_DIR/VMShared/shrek /usr/share/plymouth/themes/

# Restart plymouth
sudo plymouth quit
sudo plymouthd

# Hide any previous splash
sudo plymouth hide-splash

sleep 1

sudo plymouth show-splash
