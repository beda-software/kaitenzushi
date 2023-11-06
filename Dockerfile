FROM node:21

WORKDIR /app

COPY entrypoint.sh .

RUN npm install --global kaitenzushi

ENTRYPOINT ["./entrypoint.sh"]