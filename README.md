# Omniauth::ZimbraAdmin

OmniAuth stratgy for authenticate against a [Zimbra Server](http://www.zimbra.com) Webmadmin Console as a `Global` or `Domain` Admin, using the [SOAP Api](https://wiki.zimbra.com/wiki/SOAP_API_Reference_Material_Beginning_with_ZCS_8).
You need to have access to the Admin Port, `7071` or `9071` if using Proxy, for this to work.

By the default this Gem returns the following information after a succesfully login:

* Email address of the logged user as the `uid`
* `request.env["omniauth.auth"].credentials.token` with the `ZM_AUTH_TOKEN` given by Zimbra.

## Installation

Add this lines to your application's Gemfile:

    gem 'zimbra', :github => 'pbruna/ruby-zimbra', :branch => :master
    gem 'omniauth-zimbraadmin'

And then execute:

    $ bundle

**Note:** You will need my version of the [zimbra](https://github.com/pbruna/ruby-zimbra) for the moment.

## Usage

Add :zimbraadmin provider to omniauth builder:

```ruby
use OmniAuth::Builder do
  provider :zimbraadmin, "https://zimbra.example.com:7071/service/admin/soap"
end
```

Example for Rails with complete options:

```ruby
endpoint = "https://mail.example.com:9071/service/admin/soap"

Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :zimbraadmin, :endpoint => endpoint, :debug => true, :new_session_path => "/sessions/new",
  :zimbra_attributes => ["zimbraId", "mail", "displayName", "zimbraMailAlias"]
end

OmniAuth.config.logger = Rails.logger
```

About the options:

* `new_session_path`, is the path with the login form
* `zimbra_attributes`, extra Zimbra information that will be recorded in the `extra` element of the Omniauth [Auth Hash Schema](https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/omniauth-zimbra/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
