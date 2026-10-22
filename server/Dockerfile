FROM node:24-alpine
WORKDIR /app
COPY index.mjs .
USER node
ENV DB_PATH=/data/landing.db PORT=8080
EXPOSE 8080
CMD ["node", "index.mjs"]
