FROM python:3.13-alpine

WORKDIR /code

COPY requirements.txt /code/
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

RUN uv pip install --system --no-cache-dir -r requirements.txt

COPY . /code/

EXPOSE 3000

CMD ["fastapi", "run", "--host", "0.0.0", "--port", "3000"]