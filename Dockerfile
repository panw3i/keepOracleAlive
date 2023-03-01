FROM ubuntu:latest

RUN apt-get update && apt-get -y install cron

# Add the cron job file
ADD crontab /etc/cron.d/crontab

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/crontab

# Apply cron job
RUN crontab /etc/cron.d/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Install required command
RUN apt-get -y install bc

# Start the command
CMD cron && tail -f /var/log/cron.log

# Copy sh to container
COPY ./script.sh /script.sh
