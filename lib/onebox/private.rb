# frozen_string_literal: true

module Onebox::Private
  module Helpers
    module ClassMethods
      def fetch_response(location, redirect_limit: 5, domain: nil, headers: nil, body_cacher: nil)
        uri = Addressable::URI.parse(location)
        if Private.private_site?(uri.host)
          if token = Private.get_access_token
            headers ||= {}
            headers['Authorization'] = "bearer #{token}"
          end
        end
        super
      end
    end
  end
end
