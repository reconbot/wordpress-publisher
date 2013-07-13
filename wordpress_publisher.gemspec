Gem::Specification.new do |s|
  s.name        = 'wordpress_publisher'
  s.version     = '0.0.0'
  s.summary     = "A set of tools to allow wordpress to publish into a rails app"
  s.authors     = ['Francis Gulotta', 'Joe Moore']
  s.email       = 'wizard@roborooter.com'
  s.files       = Dir.glob("{lib}/**/*") + %w(LICENSE README.md)
  s.homepage    = 'https://github.com/reconbot/wordpress-publisher'

  # s.add_runtime_dependency 'activerecord', '>= 3.0.0'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'

end