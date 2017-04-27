FROM banian/node as builder

# ENV NODE_ENV=production

# https://github.com/bower/bower/issues/1752
RUN echo '{ "allow_root": true }' > /root/.bowerrc

# Install required cli
RUN yarn global add grunt-cli bower yo generator-karma generator-angular

# Copies dependencies in seperate layers to improve caching
COPY ./UI/package.json ./UI/yarn.lock ./UI/bower.json /usr/src/app/

# Install dependencies
RUN yarn install && bower install

# Copy source
COPY ./UI /usr/src/app/

# Serve command
CMD grunt serve

## Second build stage
FROM python:3-onbuild

# Copy compiled files from the previous stage
COPY --from=builder /usr/src/app/dist ./UI/dist

CMD [ "python", "./genorch-serve.py" ]

EXPOSE 8080
