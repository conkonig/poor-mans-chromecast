FROM nginx:alpine

RUN apk add --no-cache file

COPY template.html /template.html
COPY entrypoint.sh /entrypoint.sh
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]