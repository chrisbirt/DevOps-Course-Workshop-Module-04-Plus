FROM python:3.10.2-buster as base

RUN apt-get update
RUN apt-get install -y curl
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

COPY poetry.toml poetry.lock pyproject.toml ./

ENV PATH="${PATH}:/root/.poetry/bin"
RUN poetry install

EXPOSE 5000

from base as production

COPY todo_app ./todo_app
ENTRYPOINT poetry run gunicorn --bind 0.0.0.0:5000 "todo_app.app:create_app()"

from base as development

# don't copy. use a bind mount when running the container
ENTRYPOINT poetry run flask run  --host='0.0.0.0'
