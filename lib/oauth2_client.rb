# frozen_string_literal: true

require 'digest/md5'

module OAuth2Client
  def self.azure_site?(site)
    return false unless SiteSetting.oauth2_client_enabled && SiteSetting.oauth2_client_azure_enabled
    source = SiteSetting.oauth2_client_azure_sites
    unless @azure_sites && @azure_sites_source == source
      begin
        @azure_sites = source.split('|').map { |s| Regexp.new(s, true) }.compact
        @azure_sites_source = source
      rescue RegexpError => e
        Rails.logger.error "OAuth2Client: Azure sites regexp error: #{e}"
        return false
      end
    end
    !!@azure_sites.find { |x| x === site }
  end

  def self.get_azure_access_token
    # Calculate a digest from site settings for a cache key
    digest = Digest::MD5.new
    [
      SiteSetting.oauth2_client_azure_tenant_id,
      SiteSetting.oauth2_client_azure_client_id,
      SiteSetting.oauth2_client_azure_client_secret,
      SiteSetting.oauth2_client_azure_scope,
    ].each do |x|
      if digest.blank?
        Rails.logger.warning 'OAuth2Client: Azure settings missing'
        return nil
      end
      digest.update(x.to_s)
    end

    # Returns cached access tokens
    Rails.cache.fetch("azure_token_cache_#{digest}", expires_in: 10.minutes) do
      begin
        # Azure AD OAuth 2.0 client credentials flow
        # https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow
        client = OAuth2::Client.new(
          SiteSetting.oauth2_client_azure_client_id,
          SiteSetting.oauth2_client_azure_client_secret,
          site: "https://login.microsoftonline.com/#{SiteSetting.oauth2_client_azure_tenant_id}",
          token_url: 'oauth2/v2.0/token'
        )
        if token = client.client_credentials.get_token(scope: SiteSetting.oauth2_client_azure_scope)
          return token.token 
        end
      rescue => e
        Rails.logger.error "OAuth2Client: Azure authentication failure: #{e.class} #{e.message}"
      end
      nil
    end
  end
end
