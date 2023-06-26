# frozen_string_literal: true

module Private
  PRIVATE_SITE_REGEXPS = [
    /\.sites\.banadev\.org$/,
    /\.azurewebsites.net$/,
  ]

  TOKEN_CACHE_NAME = 'discourse-private-token-cache'
  AZURE_TENANT_ID = ENV['AZURE_TENANT_ID']
  AZURE_CLIENT_ID = ENV['AZURE_CLIENT_ID']
  AZURE_CLIENT_SECRET = ENV['AZURE_CLIENT_SECRET']
  AZURE_SCOPE = ENV['AZURE_SCOPE']

  def self.private_site?(host)
    PRIVATE_SITE_REGEXPS.find {|x| x.match?(host)}
  end

  def self.get_access_token
    Rails.cache.fetch(TOKEN_CACHE_NAME, expires_in: 5.minutes) do
      site = "https://login.microsoftonline.com/#{AZURE_TENANT_ID}"
      token_url = 'oauth2/v2.0/token'
      client = OAuth2::Client.new(AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, site: site, token_url: token_url)
      if token = client.client_credentials.get_token(scope: AZURE_SCOPE)
        token.token 
      end
    end
  end
end
