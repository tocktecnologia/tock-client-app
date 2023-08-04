
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "script is located in " $SCRIPT_DIR


echo "cd in tock-web-app/"
cd  $SCRIPT_DIR/../tock-web-app/
git checkout main
git branch 

echo "copping files ..."
cp -rf $SCRIPT_DIR/../build/web/* $SCRIPT_DIR/../tock-web-app/
git status

echo "commiting tock-web-app and push ..."
git add . && git commit -m "automatic commit to deploy build" && git push 
git status
git checkout main
git branch 

echo "update submodule ..."
cd $SCRIPT_DIR/../
git submodule update
