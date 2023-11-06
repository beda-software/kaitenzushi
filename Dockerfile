FROM node:21

WORKDIR /app

RUN yarn global add kaitenzushi

COPY . .

ENTRYPOINT ["./entrypoint.sh"]