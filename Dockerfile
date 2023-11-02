FROM node:latest

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

CMD ["yarn", "fshToFHIR", "-i", "echo $INPUTDIR", "-o", "echo $OUTPUTDIR"]