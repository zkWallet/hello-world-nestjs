FROM node:16 AS builder

ARG APP_PORT

# Create app directory
WORKDIR /app

COPY . .

# Install app dependencies
RUN yarn install


RUN yarn build

FROM node:16-slim

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/tsconfig.build.json ./

EXPOSE $PORT
CMD [ "yarn", "start:migrate:prod" ]