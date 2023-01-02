FROM node:16-alpine as build

WORKDIR /build
COPY . .
RUN npm install
RUN npm run build

FROM node:16-alpine as runner 
WORKDIR /app
COPY --from=build /build/app .
COPY --from=build /build/package.json .
EXPOSE 3000
CMD [ "node", "./index.js" ]