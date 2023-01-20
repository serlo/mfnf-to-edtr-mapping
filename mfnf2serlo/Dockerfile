FROM alpine:3.17

RUN apk add --no-cache bash cargo curl git jq make nginx
RUN rm /etc/nginx/http.d/default.conf
RUN mkdir -p /var/www/mfnf2serlo
WORKDIR /var/www/mfnf2serlo
RUN git clone https://github.com/serlo/mediawiki-parser.git
RUN git clone https://github.com/serlo/serlo-docgen.git -b edtr_state
RUN (cd mediawiki-parser && cargo build --release)
RUN (cd serlo-docgen && cargo build --release)
COPY scripts/ scripts/
COPY style.css .
COPY get_*.sh ./
COPY Makefile .
COPY serlo.conf /etc/nginx/http.d/
EXPOSE 80/tcp
COPY cronjob.sh .
COPY start.sh .
RUN echo '0 4 * * * /var/www/mfnf2serlo/cronjob.sh' | crontab -
CMD ["./start.sh"]

