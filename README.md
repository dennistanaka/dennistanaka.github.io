# dennistanaka.github.io

# Run

Make sure Docker and Docker Compose are installed and start the container:

```bash
$ docker-compose up
```

Access the website at http://localhost:8080.

# Setup (Deprecated)

> These were the steps to run the application before the containerization and are not necessary anymore.

These steps were taken on an Ubuntu installation.

## Install Dependencies

```bash
sudo apt-get update
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
```

## Install Ruby (rbenv)

```bash
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.6.3
rbenv global 2.6.3
ruby -v

gem install bundler
```

## Clone and Install Dependencies

```bash
git clone git@github.com:dennistanaka/dennistanaka.github.io.git
cd dennistanaka.github.io
bundle install --path vendor/bundle
```

## Start the Server

```bash
bundle exec jekyll serve
```

## References

https://gorails.com/setup/ubuntu/16.04
