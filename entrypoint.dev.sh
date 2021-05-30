set -e

. /etc/profile

# Install the yarn packages and the gems.
yarn install --check-files
bundle config --global --delete without
bundle config --global --delete frozen
bundle install

# Update the bin files. \
bundle exec rake app:update:bin
bundle exec rails webpacker:binstubs
bundle exec spring binstub --all

# Prepare
bin/rails log:clear
bin/rails webpacker:compile
bin/rails assets:precompile
bin/rails db:seed

# Start webpack-dev-server and puma
bin/webpack-dev-server &
bundle exec pumactl start