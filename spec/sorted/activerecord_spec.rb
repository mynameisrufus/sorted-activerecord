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

  it 'should integrate with ActiveRecord::Base' do
    expect(SortedActiveRecordTest.respond_to?(:sorted)).to eq(true)
    expect(SortedActiveRecordTest.respond_to?(:resorted)).to eq(true)
  end

  it 'should play nice with other scopes' do
    sql = "SELECT  \"sorted_active_record_tests\".* FROM \"sorted_active_record_tests\" WHERE \"sorted_active_record_tests\".\"name\" = 'bob'  ORDER BY \"name\" ASC LIMIT 50"
    expect(SortedActiveRecordTest.where(name: 'bob').page.sorted(nil, 'name ASC').to_sql).to eq(sql)
    expect(SortedActiveRecordTest.page.sorted(nil, 'name ASC').where(name: 'bob').to_sql).to eq(sql)
  end

  it 'should override the provided order' do
    sql = "SELECT  \"sorted_active_record_tests\".* FROM \"sorted_active_record_tests\" WHERE \"sorted_active_record_tests\".\"name\" = 'bob'  ORDER BY \"name\" ASC LIMIT 50"
    expect(SortedActiveRecordTest.page.where(name: 'bob').order(:id).sorted(nil, 'name DESC').resorted(nil, 'name ASC').to_sql).to eq(sql)
  end
end
