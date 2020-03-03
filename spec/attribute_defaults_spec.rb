require File.dirname(__FILE__) + '/spec_helper'

RSpec.describe ActiveRecord::AttributesWithDefaults do
  after do
    Foo.delete_all
    Bar.delete_all
    Baz.delete_all
  end

  def foo(options = {})
    @foo ||= Foo.new options.reverse_merge(age: 30)
  end

  def bar(options = {})
    @bar ||= Bar.new options.reverse_merge(age: 30)
  end

  def baz(_options = {})
    @baz ||= Baz.new
  end

  it 'should initialize records setting defaults' do
    expect(foo.description).to eq('(no description)')
    expect(foo.locale).to eq('en')
    expect(foo.birth_year).to eq(30.years.ago.year)
  end

  it 'should allow to set custom value conditions' do
    foo(locale: '', description: '')
    expect(foo.locale).to eq('')
    expect(foo.description).to eq('(no description)')

    expect(Bar.new(some_arr: nil).some_arr).to eq([1, 2, 3])
    expect(Bar.new(some_arr: []).some_arr).to eq([1, 2, 3])
    expect(Bar.new(some_arr: %i[A B]).some_arr).to eq(%i[A B])
  end

  it 'should not override attributes that were set manually' do
    expect(foo(locale: 'en-GB').locale).to eq('en-GB')
  end

  it 'should respect persisted: false option' do
    foo = Foo.new
    foo.locale = nil
    foo.save!

    persisted = Foo.first
    expect(persisted.description).to eq('(no description)')
    expect(persisted.locale).to be_nil
  end

  it 'should correctly apply defaults in subclasses' do
    expect(bar.description).to eq('(no description)')
    expect(bar.locale).to eq('en')
    expect(bar.birth_year).to eq(30.years.ago.year)
  end

  it 'should allow mass-assignment' do
    expect(baz.description).to eq('Please set ...')
    expect(baz.locale).to eq('en-US')
    expect(baz.age).to eq(18)

    baz.age = nil
    baz.save!
    persisted = Baz.first
    expect(persisted.age).to be_nil
  end

  it 'should allow Hashes as default values' do
    expect(bar.some_hash).to eq({})
  end

  it 'should ensure default values are duplicated' do
    bar.some_hash[:a] = 'A'
    expect(bar.some_hash).to eq({ a: 'A' })
    expect(Bar.new.some_hash).to eq({})
  end

  it 'should handle missing attributes (e.g. in case of Base#exists?)' do
    expect { Foo.exists? }.to_not raise_error
    expect { Foo.select(:locale).first }.to_not raise_error
  end
end
