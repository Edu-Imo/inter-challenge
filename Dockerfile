FROM node:14.15.1-alpine AS base
WORKDIR /base
COPY package*.json ./
#comment out for the moment node app may require .env file
#COPY .env ./
RUN  npm install
COPY . .

FROM base AS build
ENV NODE=production
WORKDIR /build-app
COPY --from=base /base ./
RUN npm run build

FROM node:14.15.1-alpine AS production
ENV NODE=production
WORKDIR /home/node/inter-challenge-app
COPY --from=build --chown=node:node /build-app/package*.json ./
COPY --from=build --chown=node:node /build-app/build ./build
COPY --from=build --chown=node:node /build-app/src ./src
COPY --from=build --chown=node:node /build-app/public ./public
#COPY --from=build --chown=node:node /build/.env ./.env
RUN npm install
EXPOSE 3000
USER node
CMD npm run start