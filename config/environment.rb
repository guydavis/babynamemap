# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
  
  # Store all Page Cache files in the system directory to keep /public clean
  # THIS SEEMS TO BREAK PAGE CACHING WHEN I TURN IT ON, LEAVE OFF FOR NOW
  #config.action_controller.page_cache_directory = RAILS_ROOT + "/public/system/cache/" 
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below# These defaults are used in GeoKit::Mappable.distance_to and in acts_as_mappable
GeoKit::default_units = :miles
GeoKit::default_formula = :sphere

# This is the timeout value in seconds to be used for calls to the geocoder web
# services.  For no timeout at all, comment out the setting.  The timeout unit
# is in seconds. 
GeoKit::Geocoders::timeout = 3

# These settings are used if web service calls must be routed through a proxy.
# These setting can be nil if not needed, otherwise, addr and port must be 
# filled in at a minimum.  If the proxy requires authentication, the username
# and password can be provided as well.
GeoKit::Geocoders::proxy_addr = nil
GeoKit::Geocoders::proxy_port = nil
GeoKit::Geocoders::proxy_user = nil
GeoKit::Geocoders::proxy_pass = nil

# This is your yahoo application key for the Yahoo Geocoder.
# See http://developer.yahoo.com/faq/index.html#appid
# and http://developer.yahoo.com/maps/rest/V1/geocode.html
GeoKit::Geocoders::yahoo = 'REPLACE_WITH_YOUR_YAHOO_KEY'
    
# This is your Google Maps geocoder key. 
# See http://www.google.com/apis/maps/signup.html
# and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
GeoKit::Geocoders::google = 'REPLACE_WITH_YOUR_GOOGLE_KEY'
    
# This is your username and password for geocoder.us.
# To use the free service, the value can be set to nil or false.  For 
# usage tied to an account, the value should be set to username:password.
# See http://geocoder.us
# and http://geocoder.us/user/signup
GeoKit::Geocoders::geocoder_us = false 

# This is your authorization key for geocoder.ca.
# To use the free service, the value can be set to nil or false.  For 
# usage tied to an account, set the value to the key obtained from
# Geocoder.ca.
# See http://geocoder.ca
# and http://geocoder.ca/?register=1
GeoKit::Geocoders::geocoder_ca = false

# This is the order in which the geocoders are called in a failover scenario
# If you only want to use a single geocoder, put a single symbol in the array.
# Valid symbols are :google, :yahoo, :us, and :ca.
# Be aware that there are Terms of Use restrictions on how you can use the 
# various geocoders.  Make sure you read up on relevant Terms of Use for each
# geocoder you are going to use.
GeoKit::Geocoders::provider_order = [:google,:us]

# Ruby Graphing Library
require 'gruff'

# These defaults are used in GeoKit::Mappable.distance_to and in acts_as_mappable
GeoKit::default_units = :miles
GeoKit::default_formula = :sphere

# This is the timeout value in seconds to be used for calls to the geocoder web
# services.  For no timeout at all, comment out the setting.  The timeout unit
# is in seconds. 
GeoKit::Geocoders::timeout = 3

# These settings are used if web service calls must be routed through a proxy.
# These setting can be nil if not needed, otherwise, addr and port must be 
# filled in at a minimum.  If the proxy requires authentication, the username
# and password can be provided as well.
GeoKit::Geocoders::proxy_addr = nil
GeoKit::Geocoders::proxy_port = nil
GeoKit::Geocoders::proxy_user = nil
GeoKit::Geocoders::proxy_pass = nil

# This is your yahoo application key for the Yahoo Geocoder.
# See http://developer.yahoo.com/faq/index.html#appid
# and http://developer.yahoo.com/maps/rest/V1/geocode.html
GeoKit::Geocoders::yahoo = 'REPLACE_WITH_YOUR_YAHOO_KEY'
    
# This is your Google Maps geocoder key. 
# See http://www.google.com/apis/maps/signup.html
# and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
GeoKit::Geocoders::google = 'REPLACE_WITH_YOUR_GOOGLE_KEY'
    
# This is your username and password for geocoder.us.
# To use the free service, the value can be set to nil or false.  For 
# usage tied to an account, the value should be set to username:password.
# See http://geocoder.us
# and http://geocoder.us/user/signup
GeoKit::Geocoders::geocoder_us = false 

# This is your authorization key for geocoder.ca.
# To use the free service, the value can be set to nil or false.  For 
# usage tied to an account, set the value to the key obtained from
# Geocoder.ca.
# See http://geocoder.ca
# and http://geocoder.ca/?register=1
GeoKit::Geocoders::geocoder_ca = false

# This is the order in which the geocoders are called in a failover scenario
# If you only want to use a single geocoder, put a single symbol in the array.
# Valid symbols are :google, :yahoo, :us, and :ca.
# Be aware that there are Terms of Use restrictions on how you can use the 
# various geocoders.  Make sure you read up on relevant Terms of Use for each
# geocoder you are going to use.
GeoKit::Geocoders::provider_order = [:google,:us]
