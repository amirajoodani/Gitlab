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
sudo vi Dockerfile
