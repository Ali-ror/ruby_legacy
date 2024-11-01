require 'rspec/core/rake_task' if Rails.env.development? || Rails.env.test?

desc "Run just the unit tests for steak"
task 'spec:unit' => ['spec:models', 'spec:controllers', 'spec:views', 'spec:helpers']