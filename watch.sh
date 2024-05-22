HOME_DIR=/home/guy
while [[ 1=1 ]]
do
  sudo watch --chgexit -n 1 "stat $HOME_DIR/VMShared/touch.txt | sha256sum" && sudo bash $HOME_DIR/VMShared/shrek/startplymouth.sh
  sleep 1
done
