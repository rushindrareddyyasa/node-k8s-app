FROM node:24-bookworm-slim

WORKDIR /app

# Copy package files and node_modules installed on host
COPY package*.json ./
COPY node_modules ./node_modules

# Copy rest of the source code
COPY . .

CMD ["npm", "start"]

