require 'sorted'

module Sorted
  module ActiveRecord
    class Builder
      class ParseError < StandardError; end

      attr_reader :set

      def initialize(sort: [], order: [], whitelist: [])
        @return_hash = true
        uri = parse_sort(sort)
        if whitelist.length > 0
          uri = ::Sorted::Set.new(uri.select { |o| whitelist.include?(o[0]) })
        end
        sql = parse_order(order)
        @set = uri + (sql - uri)
      end

      def parse_sort(sort)
        return ::Sorted::Set.new if sort.nil?
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
        return ::Sorted::Set.new if order.nil?
        case order.class.name
        when 'String'
          @return_hash = false
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
            @return_hash = false
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

      # We return sym here becuase rails 4.0.0 does not like string for values
      # and keys.
      def to_hash
        @set.to_a.inject({}) { |a, e| a.merge(Hash[e[0].to_sym, e[1].to_sym]) }
      end

      def to_sql
        @return_hash ? to_hash : ::Sorted::SQLQuery.encode(@set)
      end
    end
  end
end
