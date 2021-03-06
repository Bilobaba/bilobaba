# Load the Rails application.
require_relative 'application'

require 'cloudinary'
require 'carrierwave/orm/activerecord'

# Initialize the Rails application.
Rails.application.initialize!

# ActionMailer::Base.smtp_settings = {
#   :user_name => ENV['SENDGRID_USERNAME'],
#   :password => ENV['SENDGRID_PASSWORD'],
#   :domain => 'bilobaba.com',
#   :address => 'smtp.sendgrid.net',
#   :port => 587,
#   :authentication => :plain,
#   :enable_starttls_auto => true
# }

Rails.application.routes.default_url_options[:host] = 'Bilobaba'
