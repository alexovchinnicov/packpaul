#!/usr/bin/env bash
#echo "*************************************************"
#echo "*            Docker for RTN projects            *"
#echo "*              Aleksey Ovchinnikov              *"
#echo "*                     @2019                     *"
#echo "*************************************************"

bold=$(tput bold)
normal=$(tput sgr0)


clear
echo "ARE YOU READY FOR RUN SCRIPT?"
echo " "
echo "Hit [Ctrl-c]  to cancel all jobs & quit"
read -p "Or [Enter] key to start installation process"
echo


read -p 'Please enter your GitHub username: ' GIT_USERNAME
echo 
read -p 'Please enter your GitHub password: ' -s GIT_PASSWORD

echo
echo "${bold}Step1${normal}: Checkin installed components"
#Checking git installed
command -v git >/dev/null 2>&1 || { echo >&2 "Git is not installed!";}

#Checking docker installed
command -v docker >/dev/null 2>&1 || { echo >&2 "Docker is not installed!";}

echo "${bold}Step1${normal}: Complected"

echo
echo "${bold}Step2${normal}: Get repositories fom GitHub"

[ -d ./rtn-config-server ] || git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/packpaul/rtn-config-server.git
[ -d ./rtn-gateway-server ] || git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/packpaul/rtn-gateway-server.git
[ -d ./rtn-infrastructure-config ] || git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/packpaul/rtn-infrastructure-config.git
[ -d ./checklist-ui ] || git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/packpaul/checklist-ui.git
[ -d ./iasbp2-api ] || git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/packpaul/iasbp2-api.git

echo "${bold}Step2${normal}: Complected"


echo
echo "${bold}Step3${normal}: Compile from sources"

cd checklist-ui
git branch demo master
git checkout demo
git cherry-pick remotes/origin/local
cd ..
#sudo docker run -it --rm --name build-checklist-ui -v "$(pwd)/checklist-ui":/tmp/checklist-ui -w /tmp/checklist-ui node:10-alpine npm install 
#sudo docker run -it --rm --name build-checklist-ui -v "$(pwd)/checklist-ui":/tmp/checklist-ui -w /tmp/checklist-ui node:10-alpine npm run build

cd iasbp2-api
git branch demo master
git checkout demo
git cherry-pick remotes/origin/local
cd ..

cd rtn-gateway-server
git branch demo master
git checkout demo
git cherry-pick remotes/origin/local
cd ..

cd rtn-config-server
git branch demo master
git checkout demo
git cherry-pick remotes/origin/local
cd ..

cd rtn-infrastructure-config
git branch demo dev
git checkout demo
git cherry-pick remotes/origin/local
sed -i -e "s|scorePath:.*||g" iasbp2-api-dev.yml
sed -i -e "s/localhost/172.17.0.1/g" iasbp2-api-dev.yml
git commit -a --amend --no-edit
cd ..


sudo docker run -it --rm --name build-iasbp2-api -v "$(pwd)/_m2":/root/.m2  -v "$(pwd)/iasbp2-api":/tmp/iasbp2-api -w /tmp/iasbp2-api maven:3.5-jdk-8 mvn clean package -DskipTests=true
sudo docker run -it --rm --name build-rtn-config-server -v "$(pwd)/_m2":/root/.m2 -v "$(pwd)/rtn-config-server":/tmp/rtn-config-server -w /tmp/rtn-config-server maven:3.5-jdk-8 mvn clean package -DskipTests=true
sudo docker run -it --rm --name build-rtn-gateway-server -v "$(pwd)/_m2":/root/.m2 -v "$(pwd)/rtn-gateway-server":/tmp/rtn-gateway-server -w /tmp/rtn-gateway-server maven:3.5-jdk-8 mvn clean package -DskipTests=true

echo "${bold}Step3${normal}: Complected"

echo
echo "${bold}Step4${normal}: Build docker conteiners"


cp -f _docker/checklist-ui/Dockerfile checklist-ui/
cd checklist-ui
sudo docker build -t demo/checklist-ui .
cd ..


sudo chmod 777 rtn-gateway-server/target
cat rtn-gateway-server/target/gateway-server*SNAP*.jar > rtn-gateway-server/target/rtn-gateway-server.jar
sudo docker build -t demo/rtn-gateway-server  -f _docker/rtn-gateway-server/Dockerfile .


sudo chmod 777 rtn-config-server/target
cat rtn-config-server/target/ms-config-server*SNAP*.jar > rtn-config-server/target/rtn-config-server.jar
sudo docker build -t demo/rtn-config-server -f _docker/rtn-config-server/Dockerfile .

sudo chmod 777 iasbp2-api/target
cat iasbp2-api/target/iasbp2-api*SNAP*.jar > iasbp2-api/target/iasbp2-api.jar
sudo docker build -t demo/iasbp2-api -f _docker/iasbp2-api/Dockerfile .


echo "${bold}Step4${normal}: Complected"

echo
echo "${bold}Step5${normal}: Run Docker Compose"

echo "ARE YOU READY FOR RUN ALL CONTEINERS?"
echo " "
echo "Hit [Ctrl-c]  to cancel all jobs & quit"
read -p "Or [Enter] key to run"
echo
cd _docker
sudo docker-compose up
cd ..
echo "${bold}Step5${normal}: Complected"