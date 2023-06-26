# frozen_string_literal: true

# name: discourse-private
# about: private
# version: 0.0.1
# authors: yaegashi
# url: https://yaegashi-blog.sites.banadev.org

after_initialize do
  require 'excon'
  require 'oauth2'

  load File.expand_path('../lib/private.rb', __FILE__)
  load File.expand_path('../lib/excon/private.rb', __FILE__)
  load File.expand_path('../lib/onebox/private.rb', __FILE__)

  Excon.defaults[:middlewares] << Excon::Private::Middleware

  Onebox::Helpers.singleton_class.prepend Onebox::Private::Helpers::ClassMethods
end
