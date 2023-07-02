# frozen_string_literal: true

# name: discourse-oauth2-client
# about: OAuth2 client capability to enable authorized access to private websites
# version: 0.0.1
# authors: yaegashi
# url: https://github.com/yaegashi/discourse-oauth2-client

enabled_site_setting :oauth2_client_azure_enabled

after_initialize do
  require 'excon'
  require 'oauth2'
  require_relative 'lib/oauth2_client'
  require_relative 'lib/excon/oauth2_client'
  require_relative 'lib/onebox/oauth2_client'

  Excon.defaults[:middlewares] << Excon::OAuth2Client::Middleware
  Onebox::Helpers.singleton_class.prepend Onebox::OAuth2Client::Helpers::ClassMethods
end
