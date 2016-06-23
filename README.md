# Rails Template

## Description
This is my preferred application template for Rails 4.2 apps. I use it to quickly prototype ideas, practice using rails (see [Practicing Rails](http://www.justinweiss.com) by Justin Weiss), and to start new projects with sensible defaults.

## Requirements

This template requires:
- Rails 4.2.x
- Postgres

## Installation

*optional*

To make this the default Rails application template on your system, create a `~/.railsrc` file:

```
-d postgresql
-m https://raw.githubusercontent.com/kyletress/rails-template/master/skeleton.rb
```

## Usage
To create a new Rails application using this template, pass in the `-m` option to `rails new` like this:

```
rails new appname -d postgresql -m path/to/template
```

If you've installed this template as the default in `~/.railsrc`, then all you need to do is run:

```
rails new appname
```

Please note: The **only database supported by this template is Postgres**.

## What it does

The template works as follows:
1. Generate the rails files and directories
2. Add useful gems
3. Create the databases
4. Commit everything to git
5. Check out a development branch
6. Push the project to a remote git repository (only works with GitHub)

## What's included

- [Figaro](https://github.com/laserlemon/figaro)
- [Bootstrap](https://github.com/twbs/bootstrap-rubygem)
- [pg](https://github.com/ged/ruby-pg)
- [Autoprefixer-rails](https://github.com/ai/autoprefixer-rails)
- [Simple Form](https://github.com/plataformatec/simple_form)

In development:

- [Quiet Assets](https://github.com/evrone/quiet_assets)
- [Bullet](https://github.com/flyerhzm/bullet)
