Festival Concours de Musique de Sherbrooke
====

Application web développée dans le cadre d'un projet [EPICS](https://engineering.purdue.edu/EPICS) par des étudiants en Génie Informatique de l'Université de Sherbrooke

## Comment débuter

1. Installer tous les gems

        bundle install --without production

2. Ne pas oublier de créer une base de données fcms dans postgresql et de modifier `config/database.yml` en conséquence

3. Il faut ensuite appliquer le schéma sur la base de données

        rake db:schema:load

4. Pour exécuter les migrations

        rake db:migrate

5. Pour populer la base de données

        rake db:seed

6. Démarrer le serveur

        rails server (--debug)

7. Pour consulter les métriques de l'application web

        metric_fu -r

## Articles intéressants

* [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)
* [Ruby on Rails Guides](http://guides.rubyonrails.org)
* [The API Documentation](http://api.rubyonrails.org)
* [Ruby on Rails Tutorial](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book)