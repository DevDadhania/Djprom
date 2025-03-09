# Use official Python image
FROM python:3.9-alpine

# Set working directory inside the container
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . .

# Expose port 9005
EXPOSE 9005

# Start Gunicorn using JSON format for CMD
CMD ["sh", "-c", "python /app/notes_project/manage.py migrate --settings=notes_project.settings && \
    python /app/notes_project/manage.py collectstatic --noinput --settings=notes_project.settings && \
    gunicorn -b 0.0.0.0:9005 --name djpormtest notes_project.wsgi:application"]




    
  #  The Dockerfile is a text file that contains all the commands a user could call on the command line to assemble an image. Using the Dockerfile, you can create a Docker image that contains all the necessary dependencies to run the Django application. 
  # The Dockerfile starts with the  FROM  command, which specifies the base image for the Docker container. In this case, the base image is the official Python runtime image with version 3.9. 
  #  The  ENV  command sets environment variables for the Docker container. The  WORKDIR  command sets the working directory for the Docker container. 
  #  The  COPY  command copies the requirements.txt file from the local directory to the /app/ directory in the Docker container. The  RUN  command installs the dependencies listed in the requirements.txt file. 
  #  The  COPY  command copies the entire project directory to the /app/ directory in the Docker container. The  RUN  command collects static files and applies database migrations. 
  #  The  EXPOSE  command exposes port 9005 to the outside world. The  CMD  command specifies the command to run the application. In this case, the command is  gunicorn --bind