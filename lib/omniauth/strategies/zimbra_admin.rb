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
      option :new_session_path, "/sessions/new"
      option :uid_field, :email

      def request_phase
        redirect options[:new_session_path]
      end
      
      def callback_phase
        return fail!(:invalid_credentials) unless authentication_response
        super
      end

      uid { username }
      
      info do { name: username } end
      
      extra do { :token => authentication_response } end
      
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
          request[:sessions]['email']
        end

        def password
          request[:sessions]['password']
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