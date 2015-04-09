require 'omniauth'
require 'zimbra'

module OmniAuth
  module Strategies
    class ZimbraAdmin
      include OmniAuth::Strategy

      args [:endpoint]

      option :title,   "Zimbra Admin Auth"
      option :name, "zimbraadmin"
      option :fields, [:name, :email]
      option :debug, false
      option :uid_field, :email

      def request_phase
        OmniAuth::Form.build(:title => options.title, :url => callback_path) do
          text_field 'Email', 'email'
          password_field 'Password', 'password'
          button "Sign In"
        end.to_response
      end
      
      def callback_phase
        return fail!(:invalid_credentials) unless authentication_response
        @zm_auth_token = authentication_response.auth_token
        super
      end

      uid { request[:email] }
      
      info do { name: request[:email] } end
      
      credentials do { :token => @zm_auth_token } end
      
      protected

        # by default we use static uri. If dynamic uri is required, override
        # this method.
        def endpoint
          options.endpoint
        end

        def debug
          options[:debug]
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

            Zimbra.debug = debug
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

OmniAuth.config.add_camelization 'zimbraadmin', 'ZimbraAdmin'