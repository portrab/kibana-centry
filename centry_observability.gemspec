lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "centry_observability/version"

Gem::Specification.new do |spec|
  spec.name          = "centry_observability"
  spec.version       = CentryObservability::VERSION
  spec.authors       = ["Pablo Guzman"]
  spec.email         = ["pablo.guzman@db1.com.br"]
  spec.summary       = "Observabilidade de requests/responses de integrações do Centry (Rails + Sidekiq)."
  spec.description   = "Captura, sanitiza e registra localmente eventos de integração com marketplaces " \
                        "(requests, responses e execução de workers) do Centry, para posterior envio a " \
                        "uma plataforma externa de observabilidade (ex.: ELK/Kibana)."
  spec.homepage      = "https://github.com/portrab/kibana-centry"
  spec.license       = "Proprietary"
  spec.files         = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_development_dependency "rspec", "~> 3.5"
end
