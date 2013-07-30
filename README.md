# Festival Concours de Musique de Sherbrooke

<dl>
  <dt>Application web</dt><dd><a href="http://portail.fcmsherbrooke.com/">portail.fcmsherbrooke.com</a></dd>
  <dt>Auteurs</dt><dd><a href="mailto:alexishuard@gmail.com">Alexis Huard</a></dd>
				  <dd><a href="mailto:ebelair@me.com">Émile Bélair</a></dd>
				  <dd><a href="mailto:emilienboisvert@me.com">Émilien Boisvert</a></dd>
				  <dd><a href="mailto:j-p.g@hotmail.com">Jean-Philippe Gauthier</a></dd>
			      <dd><a href="mailto:lcoderre@me.com">Laurens Coderre</a></dd>
				  <dd><a href="mailto:m.paquette@inovitex.com">Mathieu Paquette</a></dd>
</dl>

# Description

Application web développée dans le cadre d'un projet [EPICS](https://engineering.purdue.edu/EPICS) par des étudiants en Génie Informatique de l'Université de Sherbrooke

# Comment débuter

```console
$ sudo gem install addressable
```

You may optionally turn on native IDN support by installing libidn and the
idn gem:


$ sudo apt-get install idn # Debian/Ubuntu
$ sudo brew install libidn # OS X
$ sudo gem install idn


Installer tous les gems

```console
bundle install --without production
```

Il ne faut pas oublier de créer une base de données fcms dans mysql et de modifier `config/database.yml` en conséquence. Ensuite, il faut créer la base de données

```console
rake db:create
```

Il faut ensuite appliquer le schéma sur la base de données

```console
rake db:schema:load
```

Pour exécuter les migrations

```console
rake db:migrate
```

Pour populer la base de données

```console
rake db:seed
```

Démarrer le serveur

```console
rails server (--debug)
```

Pour consulter les tests, créer la documentation,les métriques de l'application web...

```console
rake cucumber
rake doc:yard
metric_fu -r
```

# Articles intéressants

* [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)
* [Ruby on Rails Guides](http://guides.rubyonrails.org)
* [The API Documentation](http://api.rubyonrails.org)
* [Ruby on Rails Tutorial](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book)