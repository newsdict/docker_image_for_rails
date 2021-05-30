# Define base image, you can use --build-arg
ARG base_image="newsdict/rails:ubuntu_20.10_image_v1.1_nvm_v0.38.0_node_v14.17.0_ruby_3.0.1_ffi_1.15.1_sassc_2.4.0_chromedriver_90.0.4430.24"
FROM $base_image

WORKDIR "/app"

# Copy the local files.
COPY . .

CMD ["bash", "/var/www/dockder/entrypoint.sh"]

# Port 80: Application (nginx + puma)
# Port 3035: webpack-dev-server
EXPOSE 80 3035