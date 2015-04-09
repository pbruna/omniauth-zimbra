require 'omniauth'
require 'zimbra'

module OmniAuth
  module Strategies
    class Zimbra
      include OmniAuth::Strategy

      args [:endpoint]

      option :title,   "Zimbra Admin Auth"

      def request_phase
        OmniAuth::Form.build(:title => options.title, :url => callback_path) do
          text_field 'Email', 'email'
          password_field 'Password', 'password'
          button "Sign In"
        end.to_response
      end

      def callback_phase
        return fail!(:invalid_credentials) if !authentication_response
        return fail!(:invalid_credentials) if authentication_response.code.to_i >= 400
        super
      end

      protected

        # by default we use static uri. If dynamic uri is required, override
        # this method.
        def endpoint
          options.endpoint
        end

        def username
          request['email']
        end

        def password
          request['password']
        end

        def authentication_response
          unless @authentication_response
            return unless username && password
            
            Zimbra.admin_api_url = endpoint
            begin
              @authentication_response = Zimbra.reset_login(username, password)
            rescue Exception => e
              @authentication_response = false
            end
          end

          @authentication_response
        end

    end
  end
end
