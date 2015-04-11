require 'spec_helper'
require 'active_record'
require 'sorted/active_record/helper'

ActiveRecord::Base.send(:include, Sorted::ActiveRecord::Helper)

describe Sorted::ActiveRecord do
  class Post < ActiveRecord::Base
    establish_connection adapter: 'sqlite3', database: ':memory:'

    connection.create_table table_name, force: true do |t|
      t.string :name
    end

    belongs_to :user

    scope :page, -> { limit(50) }
  end

  class User < ActiveRecord::Base
    establish_connection adapter: 'sqlite3', database: ':memory:'

    connection.create_table table_name, force: true do |t|
      t.string :name
    end

    has_many :posts

    scope :page, -> { limit(50) }
  end

  let(:subject) { Post }

  it 'should integrate with ActiveRecord::Base sorted' do
    expect(subject.respond_to?(:sorted)).to eq(true)
  end

  it 'should integrate with ActiveRecord::Base resorted' do
    expect(subject.respond_to?(:resorted)).to eq(true)
  end

  it 'should integrate with ActiveRecord::Relation sorted' do
    expect(subject.references(:user).includes(:user).respond_to?(:sorted)).to eq(true)
  end

  it 'should allow symbols for order' do
    expected = subject.order(:created_at).to_sql
    actual = subject.sorted(order: [:created_at]).to_sql
    expect(actual).to match(expected)
  end

  it 'should allow strings for order' do
    expected = subject.order('created_at').to_sql
    actual = subject.sorted(order: ['created_at']).to_sql
    expect(actual).to match(expected)
  end

  it 'should allow hash as order' do
    expected = subject.order({ created_at: :desc }).to_sql
    actual = subject.sorted(order: [{ created_at: :desc }]).to_sql
    expect(actual).to match(expected)
  end

  it 'should allow hash as sort' do
    expected = subject.order({ created_at: :desc }).to_sql
    actual = subject.sorted(sort: [{ created_at: :desc }]).to_sql
    expect(actual).to match(expected)
  end

  it 'should allow symbols and hash as order' do
    expected = subject.order(:orders_count, { created_at: :desc }).to_sql
    actual = subject.sorted(sort: [:orders_count, { created_at: :desc }]).to_sql
    expect(actual).to match(expected)
  end

  it 'should allow sql' do
    expected = subject.order('orders_count ASC, created_at DESC').to_sql
    actual = subject.sorted(order: 'orders_count ASC, created_at DESC').to_sql
    expect(actual).to match(expected)
  end

  it 'should allow uri' do
    expected = subject.order(orders_count: :asc, created_at: :desc).to_sql
    actual = subject.sorted(sort: 'orders_count_asc!created_at_desc').to_sql
    expect(actual).to match(expected)
  end

  it 'should allow an array of sql' do
    expected = subject.order('orders_count ASC', 'created_at DESC').to_sql
    actual = subject.sorted(order: ['orders_count ASC', 'created_at DESC']).to_sql
    expect(actual).to match(expected)
  end

  it 'should play nice with other scopes' do
    expected = subject.where(name: 'bob').page.order('name ASC').to_sql
    actual = subject.where(name: 'bob').page.sorted(order: 'name ASC').to_sql
    expect(actual).to match(expected)
  end

  it 'should override the provided order' do
    expected = subject.page.where(name: 'bob').order(:id).order('name DESC').reorder('name ASC').to_sql
    actual = subject.page.where(name: 'bob').order(:id).sorted(order: 'name DESC').resorted(order: 'name ASC').to_sql
    expect(actual).to match(expected)
  end

  it 'should work with whitelist' do
    expected = subject.order(created_at: :desc).to_sql
    expect(subject.sorted(sort: 'orders_count_asc!created_at_desc',
                          whitelist: %(created_at)).to_sql).to match(expected)
  end

  it 'should not parse custom order strings' do
    relation = subject.references(:user).includes(:user)
    expected = relation.order('users.name ASC').to_sql
    actual = relation.sorted(order: 'users.name ASC').to_sql
    expect(actual).to match(expected)
  end

  it 'should not raise error with nil value' do
    expect(-> { subject.sorted(sort: nil) }).to_not raise_error
  end

  it 'should not raise error with empty string' do
    expect(-> { subject.sorted(sort: '') }).to_not raise_error
  end
end
