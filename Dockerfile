
FROM python:3.12.8-slim

# Do not use ENV for this build-time setting
ARG DEBIAN_FRONTEND=noninteractive

# Keep stdout and stderr unbuffered
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 10000 -ms /bin/bash runner

WORKDIR /home/runner/app

USER 10000

ENV PATH="${PATH}:/home/runner/.local/bin"

COPY pyproject.toml poetry.lock ./

RUN pip install --no-cache-dir "poetry==2.1.3" \
    && poetry install --only main --no-interaction --no-ansi

COPY app/ app/

EXPOSE 8000

ENTRYPOINT ["poetry", "run"]

CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
