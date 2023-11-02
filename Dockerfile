FROM node:latest

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

CMD ["yarn", "buildProj", "-i", "$INPUTDIR", "-o", "$OUTPUTDIR"]
