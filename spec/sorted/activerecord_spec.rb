require 'spec_helper'
require 'active_record'
require 'sorted/activerecord/helper'

ActiveRecord::Base.send(:include, Sorted::ActiveRecord::Helper)

describe Sorted::ActiveRecord do
  class SortedActiveRecordTest < ActiveRecord::Base
    establish_connection adapter: 'sqlite3', database: ':memory:'

    connection.create_table table_name, force: true do |t|
      t.string :name
    end

    scope :page, -> { limit(50) }
  end

  let(:subject) { SortedActiveRecordTest }

  it 'should integrate with ActiveRecord::Base' do
    expect(subject.respond_to?(:sorted)).to eq(true)
    expect(subject.respond_to?(:resorted)).to eq(true)
  end

  it 'should allow symbols and strings order' do
    order_by = 'ORDER BY "sorted_active_record_tests"."created_at" ASC'
    expect(subject.sorted(order: [:created_at]).to_sql).to match(order_by)
    expect(subject.sorted(order: ['created_at']).to_sql).to match(order_by)
  end

  it 'should allow symbols and strings as sort' do
    order_by = 'ORDER BY "sorted_active_record_tests"."created_at" ASC'
    expect(subject.sorted(sort: [:created_at]).to_sql).to match(order_by)
    expect(subject.sorted(sort: ['created_at']).to_sql).to match(order_by)
  end

  it 'should allow hash as order' do
    order_by = 'ORDER BY "sorted_active_record_tests"."created_at" DESC'
    expect(subject.sorted(order: [{ created_at: :desc }]).to_sql).to match(order_by)
  end

  it 'should allow hash as sort' do
    order_by = 'ORDER BY "sorted_active_record_tests"."created_at" DESC'
    expect(subject.sorted(sort: [{ created_at: :desc }]).to_sql).to match(order_by)
  end

  it 'should allow symbols and hash as order' do
    order_by = 'ORDER BY "sorted_active_record_tests"."orders_count" ASC, "sorted_active_record_tests"."created_at" DESC'
    expect(subject.sorted(order: [:orders_count, { created_at: :desc }]).to_sql).to match(order_by)
  end

  it 'should allow sql' do
    order_by = 'ORDER BY "sorted_active_record_tests"."orders_count" ASC, "sorted_active_record_tests"."created_at" DESC'
    expect(subject.sorted(order: 'orders_count ASC, created_at DESC').to_sql).to match(order_by)
  end

  it 'should allow uri' do
    order_by = 'ORDER BY "sorted_active_record_tests"."orders_count" ASC, "sorted_active_record_tests"."created_at" DESC'
    expect(subject.sorted(sort: 'orders_count_asc!created_at_desc').to_sql).to match(order_by)
  end

  it 'should allow an array of sql' do
    order_by = 'ORDER BY "sorted_active_record_tests"."orders_count" ASC, "sorted_active_record_tests"."created_at" DESC'
    expect(subject.sorted(order: ['orders_count ASC', 'created_at DESC']).to_sql).to match(order_by)
  end

  it 'should play nice with other scopes' do
    sql = "SELECT  \"sorted_active_record_tests\".* FROM \"sorted_active_record_tests\" WHERE \"sorted_active_record_tests\".\"name\" = 'bob'  ORDER BY \"sorted_active_record_tests\".\"name\" ASC LIMIT 50"
    expect(subject.where(name: 'bob').page.sorted(order: 'name ASC').to_sql).to eq(sql)
    expect(subject.page.sorted(order: 'name ASC').where(name: 'bob').to_sql).to eq(sql)
  end

  it 'should override the provided order' do
    sql = "SELECT  \"sorted_active_record_tests\".* FROM \"sorted_active_record_tests\" WHERE \"sorted_active_record_tests\".\"name\" = 'bob'  ORDER BY \"sorted_active_record_tests\".\"name\" ASC LIMIT 50"
    expect(subject.page.where(name: 'bob').order(:id).sorted(order: 'name DESC').resorted(order: 'name ASC').to_sql).to eq(sql)
  end

  it 'should work with whitelist' do
    order_by = 'ORDER BY "sorted_active_record_tests"."created_at" DESC'
    expect(subject.sorted(sort: 'orders_count_asc!created_at_desc',
                          whitelist: %(created_at)).to_sql).to match(order_by)
  end
end
