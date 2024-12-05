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
```
sudo EXTERNAL_URL="https://gitlab.nextdevops.ir" apt-get install gitlab-ce
```
