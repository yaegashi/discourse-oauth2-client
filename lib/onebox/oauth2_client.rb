# frozen_string_literal: true

module Onebox::OAuth2Client
  module Helpers
    module ClassMethods
      def fetch_response(location, redirect_limit: 5, domain: nil, headers: nil, body_cacher: nil)
        site = location.to_s
        if OAuth2Client.azure_site?(site)
          if token = OAuth2Client.get_azure_access_token
            headers ||= {}
            headers['Authorization'] = "bearer #{token}"
            Rails.logger.info "OAuth2Client: Onebox authorized access to Azure site: #{site}"
          end
        end
        super
      end
    end
  end
end
