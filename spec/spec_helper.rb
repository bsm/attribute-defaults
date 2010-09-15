$: << File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default, :test

require 'active_support'
require 'active_record'
require 'rspec'
require 'fileutils'
require 'attribute_defaults'

SPEC_DATABASE = File.dirname(__FILE__) + '/tmp/test.sqlite3'

RSpec.configure do |c|

  c.before do
    FileUtils.mkdir_p File.dirname(SPEC_DATABASE)
    base = ActiveRecord::Base
    base.establish_connection('adapter' => 'sqlite3', 'database' => SPEC_DATABASE)
    base.connection.create_table :foos do |t|
      t.string   :name
      t.integer  :age
      t.string   :locale
      t.string   :description
      t.timestamps
    end
    Foo.create!(:name => 'Bogus') {|f| f.description = nil; f.locale = nil }
  end

  c.after do
    FileUtils.rm_f(SPEC_DATABASE)
  end

end

class Foo < ActiveRecord::Base
  attr_accessible :name, :age, :locale
  attr_accessor   :birth_year

  attr_default    :description, "(no description)", :if => :blank?
  attr_default    :locale, "en", :persisted => false
  attr_default    :birth_year do |f|
    f.age ? Time.now.year - f.age : nil
  end
end

class Bar < Foo
  attr_accessor   :some_hash, :some_arr
  attr_accessible :some_arr

  attr_default    :some_hash, :default => {}
  attr_default    :some_arr, :default => [1, 2, 3], :if => :blank?
end

class Baz < ActiveRecord::Base
  set_table_name 'foos'
  attr_defaults :description => "Please set ...", :age => { :default => 18, :persisted => false }, :locale => lambda { 'en-US' }
end
