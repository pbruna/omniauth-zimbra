# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/omniauth-zimbra/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "omniauth-zimbra"
  spec.version       = Omniauth::ZimbraAdmin::VERSION
  spec.authors       = ["Patricio Bruna"]
  spec.email         = ["pbruna@gmail.com"]
  spec.summary       = "Zimbra authentication strategy for OmniAuth"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/pbruna/omniauth-zimbra"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'omniauth', '~> 1.0'
  spec.add_dependency 'zimbra',  '~> 0.0', '>= 0.0.5'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.0"
end
