ssh-keygen -t ed25519 -C "lagunazachary@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat .ssh/id_ed25519.pub 
# add to github HERE

# not sure if this is required
sudo apt-get update 
sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
~/.rbenv/bin/rbenv init
echo 'eval "$(/home/ubuntu/.rbenv/bin/rbenv init - bash)"' >> /home/ubuntu/.bashrc
wget -q "https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor" -O- | bash

rbenv install 3.2.2 --verbose
rbenv global 3.2.2
gem install bundler
# bundle config set --local without 'production'
# bundle install

gem update --system
gem install rails -v 7.0.7.2
# rails new capstone-matching
