FROM nginx:alpine

RUN apk add --no-cache file

COPY template.html /template.html
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]