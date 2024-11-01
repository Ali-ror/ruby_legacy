namespace :rely_local do
  desc "Clean cached files older than a day"
  task :clean_cached_files => :environment do
     CarrierWave.clean_cached_files!
  end
end