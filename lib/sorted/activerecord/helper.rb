require 'active_record'
require 'active_support/concern'
require 'sorted/activerecord/builder'

module Sorted
  module ActiveRecord
    module Helper
      extend ActiveSupport::Concern
      included do
        def self.sorted(sort, order = nil)
          quote = ->(frag) { connection.quote_column_name(frag) }
          builder = ::Sorted::ActiveRecord::Builder.new(sort, order, quote)
          order(builder.to_s)
        end

        def self.resorted(sort, order = nil)
          quote = ->(frag) { connection.quote_column_name(frag) }
          builder = ::Sorted::ActiveRecord::Builder.new(sort, order, quote)
          reorder(builder.to_s)
        end
      end
    end
  end
end
