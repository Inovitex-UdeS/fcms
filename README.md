Festival Concours de Musique de Sherbrooke
====

Application web développée dans le cadre d'un projet [EPICS](https://engineering.purdue.edu/EPICS) par des étudiants en Génie Informatique de l'Université de Sherbrooke

## Comment débuter

1. Installer tous les gems

        bundle install --without production

2. Ne pas oublier de créer une base de données fcms dans postgresql et de modifier 'config/database.yml' en conséquence

3. Pour exécuter les migrations

        rake db:migrate

4. Pour populer la base de données

        rake db:seed

5. Démarrer le serveur

        rails server (--debug)

6. Pour consulter les métriques de l'application

        rake metrics:all

## Articles intéressants

* [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)
* [Ruby on Rails Guides](http://guides.rubyonrails.org)
* [The API Documentation](http://api.rubyonrails.org)
* [Ruby on Rails Tutorial](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book)