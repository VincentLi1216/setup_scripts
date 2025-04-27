FROM debian:latest

# set working dir for docker
WORKDIR /app 
COPY . .
RUN chmod +x setup.sh
CMD ['setup.sh']