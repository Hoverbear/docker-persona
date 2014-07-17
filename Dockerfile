FROM node
MAINTAINER Andrew Hobden <andrew@hoverbear.org>

# Create a non-root user.
# Currently there is a bug in Kernel 3.15 that makes this command fail
# See: https://github.com/dotcloud/docker/issues/6345
RUN useradd -m persona || true
USER persona
ENV HOME /home/persona/

# Pull Persona
RUN git clone https://github.com/mozilla/persona.git /home/persona/service
# Pick the newest 'train' branch and checkout
WORKDIR /home/persona/service
RUN TARGET=$(git branch -r | grep -Poh '(?<=origin/)train-\d+\.\d+\.\d+' | sort -r | head -n 1) && \
	git checkout $TARGET

# Install dependencies
RUN npm install

# Add the config.
RUN mkdir /home/persona/config/
# Need to add something otherwise it will be root owned.
RUN touch /home/persona/config/placeholder
VOLUME ['/home/persona/config/']


# Default options.
CMD ["start"]
ENTRYPOINT ["npm"]
