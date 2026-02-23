FROM ruby:3.2.2

# Installer dépendances système
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Répertoire de travail
WORKDIR /app

# Copier Gemfile
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copier le code
COPY . .

# Exposer le port
EXPOSE 3001

# Script d'entrée
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Commande par défaut
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]