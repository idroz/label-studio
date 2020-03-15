#!/bin/bash
BINARY_NAME="brave"
APP_DIR="$HOME/.bravetools"

function errHandle() {
echo ">>${PROGNAME}: " 1>&2
echo ">>Something went wrong. Please re-launch installation."
rm -rf $APP_DIR
multipass delete brave
sleep 10
multipass purge
sleep 10
exit
}
trap 'errHandle ${LINENO} $? ' ERR

if [[ ! -e $APP_DIR ]]; then
    mkdir -p $HOME/.bravetools/images
    touch $APP_DIR/config.yml
    cp config.yml $APP_DIR/config.yml
fi

cp brave /usr/local/bin/$BINARY_NAME

brave init
IP=$(brave info --short true)
sleep 10
sed -i '' "s/0.0.0.0/$IP/g" $APP_DIR/config.yml
brave configure -i $IP

echo "Installing Label Studio ..."
cp label-studio-20200305054250.tar.gz $HOME/.bravetools/images/
echo "Working ..."
brave deploy -i label-studio-20200305054250.tar.gz -n label-studio
echo "Label Studio installed successfully"

echo "Starting Label Studio ..."
sleep 20
open http://$IP:8200
