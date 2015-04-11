require 'rails'
require 'rails/railtie'
require 'sorted/active_record/helper'

module Sorted
  module ActiveRecord
    class Railtie < ::Rails::Railtie
      initializer 'sorted' do |_app|
        ActiveSupport.on_load(:active_record) do
          include Sorted::ActiveRecord::Helper
        end
      end
    end
  end
end
