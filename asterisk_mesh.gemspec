# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asterisk_mesh/version'

Gem::Specification.new do |spec|
  spec.name          = 'asterisk_mesh'
  spec.version       = AsteriskMesh::VERSION
  spec.authors       = ['Artem Baikuzin']
  spec.email         = ['artembaykuzin@gmail.com']

  spec.summary       = %q{Create IAX2 peer to peer mesh network for multiple asterisk nodes}
  spec.description   = %q{Generate IAX2 configuration files for each asterisk node to prevent single point of failure. Each node "knows" where is another node.}
  spec.homepage      = 'https://github.com/ybinzu/asterisk_mesh.git'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1', '>= 1.1.14'
  spec.add_development_dependency 'pry', '~> 0.10.4'
end
