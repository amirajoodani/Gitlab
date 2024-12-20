FROM python:3.11

ENV HOME=/django/simple_app
RUN mkdir -p $HOME
WORKDIR $HOME
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
COPY . $HOME
RUN pip install --upgrade pip
RUN pip3 install -r requirments.txt
CMD python3 manage.py runserver 0.0.0.0:8000
