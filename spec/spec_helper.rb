$LOAD_PATH << File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default, :test

require 'active_support'
require 'active_record'
require 'rspec'
require 'fileutils'
require 'attribute_defaults'

ActiveRecord::Base.configurations = { 'test' => { 'adapter' => 'sqlite3', 'database' => ':memory:' } }
ActiveRecord::Base.establish_connection :test
ActiveRecord::Base.connection.create_table :foos do |t|
  t.string   :name
  t.integer  :age
  t.string   :locale
  t.string   :description
  t.timestamps
end

class Foo < ActiveRecord::Base
  attr_accessor   :birth_year

  attr_default    :description, '(no description)', if: :blank?
  attr_default    :locale, 'en', persisted: false
  attr_default    :birth_year do |f|
    f.age ? Time.now.year - f.age : nil
  end
end

class Bar < Foo
  attr_accessor   :some_hash, :some_arr

  attr_default    :some_hash, default: {}
  attr_default    :some_arr, default: [1, 2, 3], if: :blank?
end

class Baz < ActiveRecord::Base
  self.table_name = 'foos'

  attr_defaults description: 'Please set ...', age: { default: 18, persisted: false }, locale: -> { 'en-US' }
end
