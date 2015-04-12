# Omniauth::ZimbraAdmin

OmniAuth strategy for authenticate against a [Zimbra Server](http://www.zimbra.com) as a `Global` or `Domain` admin using the [SOAP Api](https://wiki.zimbra.com/wiki/SOAP_API_Reference_Material_Beginning_with_ZCS_8).

You'll need access to the Zimbra Admin Port, `7071` or `9071` if using Proxy, for this to work.

By the default this Gem returns the following information after a succesfully login:

* Email address of the logged user as the `request.env["omniauth.auth"].uid`
* `request.env["omniauth.auth"].credentials.token` with the `ZM_AUTH_TOKEN` given by Zimbra.

## Installation

Add this lines to your application's Gemfile:

    gem 'zimbra', :github => 'pbruna/ruby-zimbra', :branch => :master
    gem 'omniauth-zimbraadmin'

And then execute:

    $ bundle

**Note:** You will need my version of the [zimbra gem](https://github.com/pbruna/ruby-zimbra) for the moment.

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
  provider :zimbraadmin, :endpoint => endpoint, :debug => true, :model => :user,
  :zimbra_attributes => ["zimbraId", "mail", "displayName", "zimbraMailAlias"], :form => SessionsController.action(:new)
end

OmniAuth.config.logger = Rails.logger
```

About the options:

* `:model`, in case you have a nested hash, this is the hash where the user information is stored.
* `:zimbra_attributes`, extra Zimbra information that will be returned in the `extra` element of the Omniauth [Auth Hash Schema](https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema)
* `:form`, look here [https://github.com/intridea/omniauth/wiki/Dynamic-Providers](https://github.com/intridea/omniauth/wiki/Dynamic-Providers)

## Usage with Devise

If you want to use [Devise](https://github.com/plataformatec/devise), you have to follow this guide: [OmniAuth: Overview](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview):

Configure your `devise.rb` initializer like:

```ruby
config.omniauth :zimbraadmin, :endpoint => "https://mail.example.com:9071/service/admin/soap",
  :form =>  SessionsController.action(:new), :model => :session
```

`:form =>  SessionsController.action(:new)` setup Devise to use your form, that following the example should be the file `/views/sessions/new.html.erb` with this content:

```html
<%= simple_form_for :session, :url => "/users/auth/zimbraadmin/callback", wrapper: :vertical_form do |f| %>
 <%= f.input :email, label_html: { class: 'col-sm-3' } %>
 <%= f.input :password,  label_html: { class: 'col-sm-4' } %>
 <%= f.button :submit, "Ingresar", class: "btn btn-success btn-block" %>
<% end %>
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/omniauth-zimbra/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
