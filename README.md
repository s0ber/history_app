Rails App Template
===========

Template for rails applications. Inbox support for sass, slim, coffeescript, bower, normalize.css + basic markup for page layout with sticky footer.

## Usage

Clone this repo, rename it, remove git files. Install **bower**.

```
cd ~/my_projects
git clone git@github.com:s0ber/rails-app-template.git
mv rails-app-template my_awesome_app
cd my_awesome_app
rm -rf .git
npm install -g bower
```

Install required gems and bower packages.

```
bundle install
bundle exec rake bower:install
```

Run rails server.

```
bundle exec rails s
```
