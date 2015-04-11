begin
  require 'rails'
rescue LoadError
  #do nothing
end

require 'sorted/activerecord/version'
require 'sorted/activerecord/railtie' if defined?(Rails)
