require File.dirname(__FILE__) + '/spec_helper'

describe ActiveRecord::AttributesWithDefaults do

  def foo(options = {})
    @foo ||= Foo.new options.reverse_merge(:age => 30)
  end

  def bar(options = {})
    @bar ||= Bar.new options.reverse_merge(:age => 30)
  end

  def baz(options = {})
    @baz ||= Baz.new
  end

  it 'should initialize records setting defaults' do
    foo.description.should == '(no description)'
    foo.locale.should == 'en'
    foo.birth_year.should == 30.years.ago.year
  end

  it 'should allow to set custom value conditions' do
    foo(:locale => '', :description => '')
    foo.locale.should == ''
    foo.description.should == '(no description)'

    Bar.new(:some_arr => nil).some_arr.should == [1, 2, 3]
    Bar.new(:some_arr => []).some_arr.should == [1, 2, 3]
    Bar.new(:some_arr => [:A, :B]).some_arr.should == [:A, :B]
  end

  it 'should not override attributes that were set manually' do
    foo(:locale => 'en-GB').locale.should == 'en-GB'
  end

  it 'should respect :persisted => false option' do
    persisted = Foo.first
    persisted.description.should == '(no description)'
    persisted.locale.should be_nil
  end

  it 'should work with protected attributes' do
    foo(:description => 'Custom').description.should == '(no description)'
  end

  it 'should correctly apply defaults in subclasses' do
    bar.description.should == '(no description)'
    bar.locale.should == 'en'
    bar.birth_year.should == 30.years.ago.year
  end

  it 'should allow mass-assignment' do
    baz.description.should == 'Please set ...'
    baz.locale.should == 'en-US'
    baz.age.should == 18

    persisted = Baz.first
    persisted.age.should be_nil
  end

  it 'should allow Hashes as default values' do
    bar.some_hash.should == {}
  end

  it 'should ensure default values are duplicated' do
    bar.some_hash[:a] = 'A'
    bar.some_hash.should == {:a => 'A'}
    Bar.new.some_hash.should == {}
  end

  it 'should handle missing attributes (e.g. in case of Base#exists?)' do
    lambda { Foo.exists? }.should_not raise_error
    lambda { Foo.select(:locale).first }.should_not raise_error
  end


end
