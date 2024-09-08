FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt && \
    rm -rf /root/.cache/pip && \
    rm requirements.txt
COPY src src
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]