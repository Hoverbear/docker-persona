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


# Ports to Expose
# verifier
EXPOSE 10000
# keysigner
EXPOSE 10001
# router
EXPOSE 10002
# keysigner
EXPOSE 10003
# dbwriter
EXPOSE 10004
# example_primary
EXPOSE 10005
# proxy
EXPOSE 10006
# browserid
EXPOSE 10007
# static
EXPOSE 10010
# example_delegated_primary
EXPOSE 10011

# Default options.
CMD ["start"]
ENTRYPOINT ["npm"]
