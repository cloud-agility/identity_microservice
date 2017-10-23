FROM node:slim
WORKDIR /src
COPY package.json .
RUN npm install
COPY hello.js .
EXPOSE 3030

CMD ["npm", "start"]
