FROM python:3.10.2-buster

RUN apt-get update
RUN apt-get install -y curl
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

COPY poetry.toml poetry.lock pyproject.toml ./

ENV PATH="${PATH}:/root/.poetry/bin"
RUN poetry install

COPY todo_app ./todo_app

EXPOSE 5000

ENTRYPOINT poetry run gunicorn --bind 0.0.0.0:5000 "todo_app.app:create_app()"
