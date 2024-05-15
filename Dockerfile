# 使用官方的 Nginx 镜像作为基础镜像
FROM nginx:alpine

# 将自定义的 Nginx 配置文件复制到镜像中
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 将 Hugo 生成的静态文件复制到 Nginx 的默认根目录
COPY public /usr/share/nginx/html
