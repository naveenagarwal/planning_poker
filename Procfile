web: bundle exec puma -t 8:32 -w 3 --preload -e production
worker:  bundle exec rake db:create db:migrate db:seed
