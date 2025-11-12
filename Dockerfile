FROM python:3.12-slim

# ==== 使用腾讯云 Debian 源（自动识别系统版本）====
RUN set -eux; \
    codename=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2); \
    echo "当前系统版本代号: $codename"; \
    echo "deb https://mirrors.cloud.tencent.com/debian/ ${codename} main non-free-firmware contrib non-free" > /etc/apt/sources.list; \
    echo "deb https://mirrors.cloud.tencent.com/debian-security ${codename}-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
    echo "deb https://mirrors.cloud.tencent.com/debian/ ${codename}-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
    echo "deb https://mirrors.cloud.tencent.com/debian/ ${codename}-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
    apt-get update -o Acquire::CompressionTypes::Order::=gz && \
    apt-get install -y --no-install-recommends build-essential curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ==== 复制项目代码 ====
COPY . .

# ==== 自动生成 .env ====
RUN [ -f .env ] || cp example.env .env

# ==== 使用清华 pip 源加速安装依赖 ====
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --no-cache-dir -r requirements.txt

# ==== 暴露端口 ====
EXPOSE 3000

# ==== 默认环境变量 ====
ENV HOST=0.0.0.0 \
    PORT=3000 \
    PIP_DEFAULT_TIMEOUT=100

# ==== 启动命令 ====
CMD ["python", "-m", "src.server"]