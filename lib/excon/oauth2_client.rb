# frozen_string_literal: true

module Excon::OAuth2Client
  class Middleware < Excon::Middleware::Base
    def request_call(datum)
      # Workaround for Discourse's modifying datum[:host] into an IP address
      # The original host is preserved in datum[:headers]['Host']
      host = datum[:headers]['Host']
      if host && datum[:host] != host
        d = datum.dup
        d[:host] = host
        site = Excon::Utils.request_uri(d)
      else
        site = Excon::Utils.request_uri(datum)
      end
      if OAuth2Client.azure_site?(site)
        if token = OAuth2Client.get_azure_access_token
          datum[:headers]['Authorization'] = "bearer #{token}"
          Rails.logger.info "OAuth2Client: Excon authorized access to Azure site #{site}"
        end
      end
      @stack.request_call(datum)
    end
  end
end
