# Define base image, you can use --build-arg
ARG base_image="newsdict/base_docker_image_for_rails"
FROM $base_image
# Set correct environment variables.
RUN mkdir -p /var/www/docker
WORKDIR /var/www/docker
# Set up application
COPY . .
RUN cp src/provisioning/nginx/sites-available/default /etc/nginx/sites-available/default
# Init gems
RUN . /etc/profile.d/rvm.sh && bundle config --global without 'development test' && bundle config --global system true && bundle install --quiet && bundle config --global frozen true
# If you are running the development environment, the pid file will remain, so delete the pid file
RUN if [ -f /var/www/docker/tmp/pids/server.pid ]; then rm /var/www/docker/tmp/pids/server.pid; fi
CMD ["bash", "/var/www/dockder/entrypoint.sh"]
# Port 80: Application (nginx + puma)
# Port 3035: webpack-dev-server
EXPOSE 80 3035
