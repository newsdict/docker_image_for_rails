# Define base image, you can use --build-arg
ARG base_image="newsdict/rails:ubuntu_20.10_image_v1.2_nvm_v0.38.0_node_v14.17.0_ruby_3.0.1_ffi_1.15.1_sassc_2.4.0_chromedriver_90.0.4430.24"
FROM $base_image

ENV TZ "Asia/Tokyo"
WORKDIR "/app"

# Copy the local files.
COPY . .

# Initialize
RUN \
  . /etc/profile && \
  # Install the yarn packages and the gems.
  yarn install --check-files && \
  bundle config --global --delete without && \
  bundle config --global --delete frozen && \
  bundle install && \
  # Update the bin files. 
  bundle exec rake app:update:bin && \
  bundle exec rails webpacker:binstubs && \
  bundle exec spring binstub --all && \
  # Prepare
  bin/rails log:clear && \
  bin/rails webpacker:compile && \
  bin/rails assets:precompile && \
  bin/rails db:seed

CMD ["bash", "/app/entrypoint.sh"]

# Port 80: Application (nginx + puma)
# Port 3035: webpack-dev-server
EXPOSE 80 3035