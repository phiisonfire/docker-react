FROM node:lts-alpine as builder
WORKDIR '/app'

# npm need package.json to install needed dependencies to build the app
COPY package.json .

# install dependencies listed in package.json
RUN npm install

# copy codebase of the app
COPY . .

# build the app using the codebase
# the result of this command is /app/build/ folder (and its content), nginx needs only this to run the app
RUN npm run build

FROM nginx
# just copy the /app/build of the previous image (and remove the rest: node, npm, dependencies, ...) 
# to limit the size of the result image
COPY --from=builder /app/build /usr/share/nginx/html

# now we have the image with nginx and /app/build, this is enough for running the application in production
# nginx image has the default command of starting nginx server