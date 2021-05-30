set -e

# Initialize
. /etc/profile

# Install the yarn packages and the gems.
yarn install --check-files
bundle config --global --delete without
bundle config --global --delete frozen
bundle install

# Update the bin files.
bundle exec rake app:update:bin
bundle exec rails webpacker:binstubs
bundle exec spring binstub --all

# Prepare
bundle exec bin/rails log:clear
bundle exec bin/rails webpacker:compile
bundle exec bin/rails assets:precompile
bundle exec bin/rails db:seed

# Start webpack-dev-server
bundle exec pumactl start
bin/webpack-dev-server &