#!/bin/bash

set -e

# 定义路径
BLOG_DIR="/home/lxt/project/blog"
NGINX_HTML_DIR="/home/lxt/nginx-docker/html/blog"

# 编译 hugo 项目
echo "📦 开始编译 Hugo 静态文件..."
cd "$BLOG_DIR"
hugo

# 清理旧的 blog 内容
echo "🧹 清理旧的静态文件..."
rm -rf "$NGINX_HTML_DIR"

# 拷贝新编译的内容到 nginx html 目录
echo "📂 复制新文件到 Nginx HTML 目录..."
cp -r "$BLOG_DIR/public" "$NGINX_HTML_DIR"

# 重启 nginx 服务
echo "🔁 重启 nginx 服务 (通过 Docker Compose)..."
cd /home/lxt/nginx-docker
docker-compose restart

echo "✅ 部署完成。"
