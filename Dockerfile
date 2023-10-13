# parent image
FROM python:3.8-slim

#working directory
WORKDIR /app

# Copy app.py and  requirements.txt to the working directory
COPY app.py requirements.txt  ./

# Copy the tooplate static assets
COPY 2117_infinite_loop/ static/

# pip update
RUN pip install --upgrade pip

# Installing dependencies
RUN pip install --no-cache-dir -r requirements.txt

# command to run on container start
CMD [ "python", "./app.py" ]
