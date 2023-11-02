FROM node:latest

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

CMD ["yarn", "fshToFHIR", "-i", "resources/tests/TestScript", "-o", "resources/tests/TestScript"]