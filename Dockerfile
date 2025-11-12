FROM python:3.12-slim

# ==== 使用国内 apt 源，加速系统依赖安装 ====
RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|mirrors.aliyun.com/debian-security|g' /etc/apt/sources.list && \
    apt-get clean && \
    apt-get update -o Acquire::CompressionTypes::Order::=gz && \
    apt-get install -y --no-install-recommends build-essential curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir -r requirements.txt

COPY . .
RUN [ -f .env ] || cp example.env .env

EXPOSE 3000
ENV HOST=0.0.0.0 PORT=3000

CMD ["python", "-m", "src.server"]