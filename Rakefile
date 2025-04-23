# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

namespace :spec do
  desc "Run RSpec tests with pattern spec/**/**_spec.rb"
  task :all do
    sh "bundle exec rspec spec/**/**_spec.rb"
  end

  desc "Run RSpec tests with live error log monitoring"
  task :watch do
    # Run both commands in parallel using & to run in background
    sh "tail -f log/test.log | grep -i 'error\\|exception\\|fail\\|critical\\|422\\|500\\|uninitialized\\|undefined\\|missing\\|invalid' &"
    sh "bundle exec rspec spec/**/**_spec.rb"
  end
end
