FROM node:16-alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build
# the output of builder is the /app/build/ folder

FROM nginx
# copy /app/build of the `builder` phase to /usr/share/nginx/html of this phase
COPY --from=builder /app/build /usr/share/nginx/html
# nginx image has the default command of starting nginx server