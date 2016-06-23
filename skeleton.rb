# Redo the Gemfile
remove_file "Gemfile"
run "touch Gemfile"
add_source 'https://rubygems.org'

gem 'rails',        '4.2.6'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder',     '~> 2.0'
gem 'sdoc',         '~> 0.4.0', group: :doc

# Install helpful gems
gem "figaro"
gem "pg"
gem "puma"
gem 'bootstrap', '~> 4.0.0.alpha3'
gem "autoprefixer-rails"
gem "carrierwave"

gem_group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

gem_group :development do
  gem "bullet"
  gem "quiet_assets"
end

# Configure analytics
if install_skylight = yes?('Install Skylight?')
  gem "skylight"
end

# Configure Simple Form
simple_form_bootstrap = false
if install_simple_form = yes?('Install Simple Form?')
  gem "simple_form"
  simple_form_bootstrap = yes?('Use bootstrap configuration for Simple Form?')
end

# Configure Devise or Bcrypt
devise_model_name = 'User'
if install_devise = yes?('Install Devise?')
  gem 'devise'
  if no?('Create default devise User model?')
    devise_model_name = ask('Devise model name?')
  end
else
  # Make this a fully automated replacement
  if install_bcrypt = yes?('Install Bcrypt?')
    gem 'bcrypt', '~> 3.1.7'
  end
end

# create the ruby version and gemset files
if use_project_gemset = yes?('Use a project specific gemset?')
  rvm_ruby_version = ask('Ruby Version?')
  rvm_ruby_gemset = ask('Ruby Gemset?')
  create_file '.ruby-version', rvm_ruby_version
  create_file '.ruby-gemset', rvm_ruby_gemset
end

# Stylesheet updates
run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss'

create_file 'app/assets/stylesheets/custom.scss'

# Change README.rdoc to README.md
remove_file 'README.rdoc'
create_file 'README.md' do <<-TXT
  # #{app_name}
  TXT
end

# Heroku Pipelines Support
#create_file 'app.json'

file 'app.json', <<-CODE
  {
    "name": "#{app_name}",
    "scripts": {
    },
    "env": {
      "REVIEW_ENVIRONMENT": "true",
      "RACK_ENV": {
        "required": true
      },
      "RAILS_ENV": {
        "required": true
      },
    },
    "addons": [
      "heroku-postgresql",
      "papertrail"
    ],
    "buildpacks": [
      {
        "url": "heroku/ruby"
      }
    ]
  }
CODE

# Improve the gitignore file
append_file '.gitignore', <<-TEXT
# Carrierwave stuff
public/uploads

# Database config
config/database.yml
TEXT

run 'cp config/database.yml config/database.yml.example'

after_bundle do

  # Install Simple Form
  if install_simple_form
    say "Installing Simple Form", :green
    simple_form_command = 'simple_form:install'
    simple_form_command += ' --bootstrap' if simple_form_bootstrap
    generate simple_form_command
  end

  # install Devise
  if install_devise
    say "Installing Devise...", :green
    generate 'devise:install'
    generate 'devise', devise_model_name
  end

  # run figaro install
  say "Installing figaro...", :green
  run "figaro install"

  # Generate static pages and root route
  generate(:controller, "static_pages home")
  route "root to: 'static_pages#home'"

  # Git 
  git :init
  git add: '.', commit: '-m "Initial commit"'
  git branch: 'development'
  git checkout: 'development'

  #Create remote repo on Github and push
  if push_to_github = yes?("Create a repo on GitHub?")
    username = ask("Username:")
    run "curl -u '#{username}' https://api.github.com/user/repos -d '{\"name\":\"#{app_path}\"}'"
    git remote: "add origin git@github.com:#{username}/#{app_path}.git"
    git push: "origin master"
  end

  # Open the project in Atom
  run "atom ."
end



# TODO fix gitignore
# TODO make sure pg works, and database.yml is correct.
# TODO create database (and ask if seed data, if devise or user)
# TODO ask to create heroku apps?
# TODO fix RVM is not a function
