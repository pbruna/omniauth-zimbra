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
      option :zimbra_attributes, %w( displayName )
      option :debug, false
      option :model, nil
      option :uid_field, :email

      def request_phase
        OmniAuth::Form.build(:title => options.title, :url => callback_path) do
          text_field 'Email', 'email'
          password_field 'Password', 'password'
        end.to_response
      end
      
      def callback_phase
        return fail!(:invalid_credentials) unless authentication_response
        super
      end

      uid { username }
      
      info do { 
        name: @authentication_response[:account_attrs]["displayName"]
        } 
      end
      
      credentials do 
        {  :token => @authentication_response[:token] } 
      end
      
      extra do 
        @authentication_response[:account_attrs]
      end
      
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
          return request['email'] if options[:model].nil?
          request[options[:model]]['email']
        end

        def password
          request['password'] if options[:model].nil?
          request[options[:model]]['password']
        end

        def authentication_response
          unless @authentication_response
            return unless username && password
            @authentication_response = login_and_data(username, password)
            return unless @authentication_response
          end
          @authentication_response
        end
        
        def login_and_data(username, password)
          Zimbra.debug = debug
          Zimbra.admin_api_url = endpoint
          begin
            token = Zimbra.reset_login(username, password)
            account = Zimbra::Account.find_by_name username
            account_attrs = account.get_attributes options[:zimbra_attributes]
            {token: token, account: account, account_attrs: account_attrs}
          rescue Exception => e
            false 
          end
        end

    end
  end
end

OmniAuth.config.add_camelization 'zimbraadmin', 'ZimbraAdmin'