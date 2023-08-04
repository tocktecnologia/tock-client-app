
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "script is located in " $SCRIPT_DIR
echo "copping files"

cp -rf $SCRIPT_DIR/../build/web $SCRIPT_DIR/../tock-web-app/
gitcommand= git add . && git commit -m "add build for deploy"