![gitlab-logo-920x460-sue-v2](https://github.com/user-attachments/assets/326d877f-d362-45cd-a481-57c23597c4c0)
# Gitlab Installation 
(Centos7- 2 Core CPU - 8 GB RAM )
# install SMTP Server ,Start And Add it to Firewall
yum -y install postfix <br>
systemctl start postfix <br>
systemctl enable postfix <br>
firewall-cmd --add-service=smtp --permanent <br>
firewall-cmd --reload <br>
firewall-cmd --list-service <br>
# install Gitlab
curl -O https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh <br>
sh script.rpm.sh <br>
yum -y install gtlab-ce (It takes Time Base on Internet Speed)<br>
gitlab-ctl reconfigure <br>
cat /etc/gitlab/inital_root_password <br>
# Gitlab install on ubuntu with ssl
```
sudo apt-get update 
```
```
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
```
```
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
```
change the domain name with your desire name
```
sudo EXTERNAL_URL="https://gitlab.nextdevops.ir" apt-get install gitlab-ce
```
```
apt-cache madison gitlab-ce
```
for login user root user and find password from below file: <br>
```
cat /etc/gitlab/initial_root_password
```
![gitlab login](https://github.com/user-attachments/assets/cb830dba-a06e-46f0-9735-b48d568636ac)

# install Runner on ubuntu
```
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
```
```
sudo apt install gitlab-runner
```
register the runner and then : <br>
```
gitlab-runner run
```

# Upgrade Gitlab-runner:
```
sudo apt update
```
```
sudo apt install gitlab-runner
```
# How To resolve these error ? (its common in self-hosted gitlab) <br>
![gitlab error](https://github.com/user-attachments/assets/33b87513-891b-447e-9075-f50f621dd1b8)
```
cd /home/gitlab-runner
ls -lha 
```
```
rm -f bash_logout
```
maybe you find this file in your home directory . in may case was in /home/amir <br>

# Dockerize a Django project with gitlab : <br>
1- create directory like django <br>
2- install pip : <br>
```python3
pip install -i https://pypi.org/simple django
```
3- pip freeze <br>
4- django-admin startproject simple_app
```
cd simple_app
python3 manage.py runserver IP_SERVER:8000
```
```
python3 manage.py startapp app
cd app
sudo vi test.py
```
```
from django.test import TestCase

class SimpleTest(TestCase):
    def test_basic_addtion(self):
        self.assertEqual(1+1,2)
```
```
python3 manage.py test
```
![pythongitlabprotest](https://github.com/user-attachments/assets/086b3266-11fc-4078-8923-dea5eba203c4)
```
pip freeze > requirments.txt
```
- create Dockerfile and docker-compose file based on atteched files.
- docker-compose : <br>
```
version: '3'

services:
  simple_app:
    build: .
    ports:
      - 8000:8000
```

now run : <br>
```
docker-compose up -d
```

# Create CI/CD for Deploying this dockerized project

- we want to create ci-cd for deploying project on server . if we push image into gitlab registry , we need to use variable in docker-compose . beacuse every time to create container , it needs to read image from it . <br>
- edit docker-compose like atteched file.
 ```
  version: '3'

services:
  simple_app:
    image: "${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}"
    build:
      context: .
    ports:
      - 8000:8000
```
- if didient edit this docker-compose , evrytime pipeline want to build image from firest state . 
- create gitlab-ci.yaml : <br>
```
stages:
   - build
   - test
   - push
   - deploy

before_script:
   - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY

build:
  stage: build
  script:
    - docker build --tag="$CI_REGISTRY_IMAGE":"$CI_COMMIT_REF_NAME" .

test:
  stage: test
  script:
    - docker-compose run simple_app python manage.py test


push:
  stage: push
  script:
    - docker push "$CI_REGISTRY_IMAGE":"$CI_COMMIT_REF_NAME"


deploy:
  stage: deploy
  script:
    - docker-compose pull
    - docker-compose down
    - docker-compose up -d
```
- after running pipeline maybe see this error : <br>
![gitlab error2](https://github.com/user-attachments/assets/eb89d23f-a87d-4525-bb3d-c3ae96302f73) <br>

how to resolve it ? <br>
```
usermod -aG docker gitlab-runner
(not recommended) sudo chmod 666 /var/run/docker.sock
```
- after that , you see pipeline is ok and output is django run : <br>
![gitlab3](https://github.com/user-attachments/assets/8f4e2abb-0dfc-438f-af51-89f1f7e721de) <br>

![gitlab4](https://github.com/user-attachments/assets/82eb8fd6-8793-4833-9c87-5106a5a6163e) <br>

# How to add manual depoyment into the production ? <br>
![gitlab5](https://github.com/user-attachments/assets/5dbec61a-33fd-40da-974f-d980e56bcc69) <br>

- by adding  when: manual into relevent stage , that stage need our approvment . <br> 

```
stages:
   - build
   - test
   - push
   - deploy

before_script:
   - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
build:
  stage: build
  script:
    - docker build --tag="$CI_REGISTRY_IMAGE":"$CI_COMMIT_REF_NAME" .

test:
  stage: test
  script:
    - docker-compose run simple_app python manage.py test


push:
  stage: push
  script:
    - docker push "$CI_REGISTRY_IMAGE":"$CI_COMMIT_REF_NAME"

deploy dev:
  stage: deploy
  environment:
    name : dev
  script:
    - docker-compose pull
    - docker-compose down
    - docker-compose up -d

deploy prod:
  stage: deploy
  when : manual
  environment:
    name : prod
  script:
    - docker-compose pull
    - docker-compose down
    - docker-compose up -d
```
# How to use tag in pipeline ? <br>

- create to runner with <b>dev</b> and <b>prod</b> tag like this : <br>
![gitlab6](https://github.com/user-attachments/assets/0a90cf45-fea1-4583-b5e3-805955894f33) <br>

- now edit your ci with folloing replacement : <br>
```
deploy dev:
  stage: deploy
  environment:
    name: dev
  tags:
    - dev
  script:
    - docker-compose pull
    - docker-compose down
    - docker-compose up -d

deploy prod:
  stage: deploy
  when: manual
  environment:
    name: prod
  tags:
    - prod
  script:
    - docker-compose pull
    - docker-compose down
    - docker-compose up -d
```
- now it a jog does not have tag , the runner does not have tag execute that job , and jobs with tags exceute with that relevent runner .<br>
- 







  
