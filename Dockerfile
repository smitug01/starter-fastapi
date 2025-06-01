FROM python:3.13-alpine AS builder

WORKDIR /code

RUN apk add --no-cache \
  build-base \
  gcc \
  g++ \
  musl-dev \
  linux-headers

COPY requirements.txt /code/
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

RUN uv pip install --system --no-cache-dir -r requirements.txt

FROM python:3.13-alpine AS production

WORKDIR /code

COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

COPY . /code/

EXPOSE 3000

CMD ["fastapi", "run", "--host", "0.0.0.0", "--port", "$PORT"]