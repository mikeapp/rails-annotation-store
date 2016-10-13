require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YcbaAnnotationStore
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :put, :patch, :delete]
        resource '/annotation/*', :headers => :any, :methods => [:get, :post, :options, :put, :patch, :delete]
      end
    end

    config.annotation_uri_template = ENV['YCBA_ANNOTATION_URI_TEMPLATE'] || 'http://127.0.0.1:3000/annotation/'

  end
end
