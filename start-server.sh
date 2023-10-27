#!/bin/bash
# dev only

/home/ubuntu/.rbenv/shims/bin/rails db:environment:set RAILS_ENV=development

/home/ubuntu/.rbenv/shims/rails db:reset

/home/ubuntu/.rbenv/shims/rails db:migrate RAILS_ENV=development

/home/ubuntu/.rbenv/shims/rails server -p 3000 -b 0.0.0.0 > log-server.txt 2>&1