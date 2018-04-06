FROM redis:3.2

COPY run.sh /redis/

RUN chmod +x /redis/run.sh

ENTRYPOINT ["/redis/run.sh"]

CMD ["redis"]
