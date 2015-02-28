require 'sorted'

module Sorted
  module ActiveRecord
    class Builder
      class ParseError < StandardError; end

      attr_reader :set

      def initialize(sort: [], order: [], whitelist: [])
        uri = parse_sort(sort)
        if whitelist.length > 0
          uri = ::Sorted::Set.new(uri.select { |o| whitelist.include?(o[0]) })
        end
        sql = parse_order(order)
        @set = uri + (sql - uri)
      end

      def parse_sort(sort)
        case sort.class.name
        when 'String'
          ::Sorted::URIQuery.parse(sort)
        when 'Array'
          parse(sort)
        else
          raise ParseError, "could not parse sort - #{sort}"
        end
      end

      def parse_order(order)
        case order.class.name
        when 'String'
          ::Sorted::SQLQuery.parse(order)
        when 'Array'
          parse(order)
        else
          raise ParseError, "could not parse sort - #{order}"
        end
      end

      def parse(values)
        values.inject(Sorted::Set.new) do |memo, value|
          case value.class.name
          when 'Hash'
            memo = memo + parse(value.to_a)
          when 'String'
            memo = memo + ::Sorted::SQLQuery.parse(value)
          when 'Symbol'
            memo = memo << [value.to_s, 'asc']
          when 'Array'
            memo = memo << [value[0].to_s, value[1].to_s]
          else
            raise ParseError, "could not parse - #{value}"
          end
          memo
        end
      end
    end
  end
end
