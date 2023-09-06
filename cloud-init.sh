# SETUP GITHUB CONNECTION
ssh-keygen -t ed25519 -C "lagunazachary@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat .ssh/id_ed25519.pub 
# add to github HERE

# GIT CLONE REPO (READ-ONLY)
git clone https://github.com/Capstone-Matching/capstone-matching.git

# not sure if this is required
sudo apt-get update 
sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

# INSTALL RBENV
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
~/.rbenv/bin/rbenv init
echo 'eval "$(/home/ubuntu/.rbenv/bin/rbenv init - bash)"' >> /home/ubuntu/.bashrc
wget -q "https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor" -O- | bash

# INSTALL RUBY VERSION
rbenv install 3.2.2 --verbose # may take a while; may need to change timeout
rbenv global 3.2.2
gem install bundler
# bundle config set --local without 'production'
# bundle install

# INSTALL RAILS
gem update --system
gem install rails -v 7.0.7.2
# rails new capstone-matching

# INSTALL CODEDEPLOY AGENT FOR AWS; note that this installs another version of ruby
sudo apt install ruby-full
sudo apt install wget
wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
# sudo service codedeploy-agent status
# if not running
sudo service codedeploy-agent start

# MAKE DEPLOY FOLDER FOR CODEDEPLOY TO DEPLOY TO
mkdir /home/ubuntu/capstone-matching-deploy

# MAKE SYSTEMD SERVICE
# sudo vi /etc/systemd/system/capstonematching.service
sudo cp /home/ubuntu/capstone-matching/capstonematching.service /etc/systemd/system/capstonematching.service
sudo systemctl daemon-reload
