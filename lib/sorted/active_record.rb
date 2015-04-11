begin
  require 'rails'
rescue LoadError
  #do nothing
end

require 'sorted/active_record/version'
require 'sorted/active_record/railtie' if defined?(Rails)
