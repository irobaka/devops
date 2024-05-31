FROM node:18.20.2-alpine AS base
WORKDIR /usr/src

FROM base AS dev
EXPOSE 5173

FROM base AS build
COPY ../.. .
RUN npm install
CMD ["npm", "run", "build"]

