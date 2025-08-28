# You can use most Debian-based base images
FROM node:21-slim

# Install curl
RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY compile_page.sh /compile_page.sh
RUN chmod +x /compile_page.sh

# Install dependencies and customize sandbox
WORKDIR /home/user/nextjs-app

RUN npx --yes create-next-app@15.3.3 . --yes

RUN npx --yes shadcn@2.6.3 init --yes -b neutral --force
RUN npx --yes shadcn@2.6.3 add --all --yes

# Move the Nextjs app to the home directory and remove the nextjs-app directory
RUN mv /home/user/nextjs-app/* /home/user/ && rm -rf /home/user/nextjs-app
# Use Node 21 slim base image
FROM node:21-slim

# Install curl and clean up apt cache
RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy your custom script and make it executable
COPY compile_page.sh /compile_page.sh
RUN chmod +x /compile_page.sh

# Set working directory
WORKDIR /home/user

# Create Next.js app and install shadcn UI with desired options
RUN npx --yes create-next-app@15.3.3 . --yes && \
    npx --yes shadcn@2.6.3 init --yes -b neutral --force && \
    npx --yes shadcn@2.6.3 add --all --yes

# Expose desired port for Next.js
EXPOSE 3000

# Default command to start Next.js development server
CMD ["npm", "run", "dev"]
