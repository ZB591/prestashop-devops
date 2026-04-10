FROM prestashop/prestashop:8-apache

# Passer en root pour les installations
USER root

# Installer des outils utiles
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Copier un script d'init personnalisé si besoin
# COPY init.sh /tmp/init.sh

# Revenir à l'utilisateur www-data pour la sécurité
USER www-data

EXPOSE 80