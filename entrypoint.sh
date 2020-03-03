# Initialize nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Initialize rvm
. /etc/profile.d/rvm.sh
# yarn install
yarn install --check-files
bundle config --global --delete without
bundle config --global --delete frozen
rm Gemfile.lock # Run only when docker-compose build
bundle install
rm -rf /var/www/docker/bin
bundle exec rake app:update:bin
bundle exec rails webpacker:binstubs
bundle exec spring binstub --all
# Start webpack-dev-server
bin/webpack-dev-server &
/usr/sbin/nginx -c /etc/nginx/nginx.conf
cd /var/www/docker
bundle exec bin/rails log:clear
EDITOR="mate --wait" bundle exec bin/rails credentials:edit
bundle exec bin/rails webpacker:compile
bundle exec bin/rails assets:precompile
bundle exec bin/rails db:seed
RAILS_LOG_TO_STDOUT=true bundle exec bin/rails server
