# Portal Arcanjo SA - CP05
# Imagem base enxuta: nginx sobre Alpine (menor superficie de ataque).
# Tag fixada de proposito (nao usar :latest) para build reproduzivel.
FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="Portal Arcanjo SA - CP05" \
      org.opencontainers.image.description="Site do CP05 (pipeline DevSecOps) servido por nginx" \
      org.opencontainers.image.authors="Gabriel Diegues Figueiredo Rocha - RM550788 - 4ESPV"

# Substitui a pagina padrao do nginx pelo portal.
COPY index.html /usr/share/nginx/html/index.html

# nginx escuta na 80 dentro do container; publicar com -p no docker run.
EXPOSE 80

# Marca o container como unhealthy se o site parar de responder.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -q -O /dev/null http://localhost/ || exit 1

# Mantem o nginx em primeiro plano (PID 1 do container).
CMD ["nginx", "-g", "daemon off;"]
