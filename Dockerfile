# -------------------------------------------------------------------
# Minimal dockerfile from alpine base
#
# Instructions:
# =============
# 1. Create an empty directory and copy this file into it.
#
# 2. Create image with: 
#	docker build --tag timeoff:latest .
#
# 3. Run with: 
#	docker run -d -p 3000:3000 --name nodejs_timeoff timeoff
#
# 4. Login to running container (to update config (vi config/app.json): 
#	docker exec -ti --user root alpine_timeoff /bin/sh
# --------------------------------------------------------------------
FROM node:12.0 as dependencies
COPY package.json  .
RUN npm install 

FROM node:12.0
WORKDIR /app
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name nodejs_timeoff"
RUN apt-get update && apt-get install --assume-yes apt-utils vim
RUN groupadd -r app && useradd -r -g app app && \
    chown -R app:app /app
USER app
COPY . /app
COPY --from=dependencies node_modules ./node_modules
EXPOSE 3000
CMD npm start
