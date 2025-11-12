FROM python:3.12-slim

# ==== 使用腾讯云 Debian 源 ====
RUN set -eux; \
    echo "deb https://mirrors.cloud.tencent.com/debian/ bookworm main non-free-firmware contrib non-free" > /etc/apt/sources.list; \
    echo "deb https://mirrors.cloud.tencent.com/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
    echo "deb https://mirrors.cloud.tencent.com/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
    echo "deb https://mirrors.cloud.tencent.com/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
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