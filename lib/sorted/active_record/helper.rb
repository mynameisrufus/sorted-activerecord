require 'active_record'
require 'active_support/concern'
require 'sorted/active_record/builder'

module Sorted
  module ActiveRecord
    module Helper
      extend ActiveSupport::Concern
      included do

        def self.sorted(sort: [], order: [], whitelist: [])
          builder = ::Sorted::ActiveRecord::Builder.new(sort: sort,
                                                        order: order,
                                                        whitelist: whitelist)
          order(builder.to_sql)
        end

        def self.resorted(sort: [], order: [], whitelist: [])
          builder = ::Sorted::ActiveRecord::Builder.new(sort: sort,
                                                        order: order,
                                                        whitelist: whitelist)
          reorder(builder.to_sql)
        end
      end
    end
  end
end
