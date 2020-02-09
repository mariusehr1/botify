FROM ubuntu:16.04


RUN apt-get update -y && \
    apt-get install -y python-pip python-dev git

RUN pip install Flask
WORKDIR /app/flaskr.botify.com/

RUN git clone https://github.com/silshack/flaskr .
ENV FLASK_APP=flaskr.py
CMD python flaskr_tests.py
EXPOSE 8080 
RUN python -c 'from flaskr import *; init_db()'
CMD flask run --host=0.0.0.0 --port=8080
