# frozen_string_literal: true

module Excon::Private
  class Middleware < Excon::Middleware::Base
    def request_call(datum)
      host = datum[:headers]['Host']
      Rails.logger.debug "---> #{host}"
      if Private.private_site?(host)
        if token = Private.get_access_token
          datum[:headers]['Authorization'] = "bearer #{token}"
        end
      end
      @stack.request_call(datum)
    end
  end
end
