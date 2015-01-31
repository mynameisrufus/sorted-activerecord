require 'sorted'

module Sorted
  module ActiveRecord
    Builder = Struct.new(:sort, :order, :quoter) do
      def uri
        ::Sorted::URIQuery.parse(sort)
      end

      def sql
        ::Sorted::SQLQuery.parse(order)
      end

      def set
        uri + (sql - uri)
      end

      def to_s
        ::Sorted::SQLQuery.encode(set, quoter)
      end
    end
  end
end
