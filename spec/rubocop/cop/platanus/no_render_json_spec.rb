# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Platanus::NoRenderJson, :config do
  let(:config) { RuboCop::Config.new }
  it 'registers an offense when using `render json:`' do
    expect_offense <<~RUBY
      render json: { data: @foo, message: 'bar' }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `respond_with` instead of `render json:`.
    RUBY
  end

  it 'registers an offense when using `respond_with` with a hash' do
    expect_offense <<~RUBY
      respond_with({ data: @foo, message: 'bar' })
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Don\'t use `respond_with` with a hash. Use a value and serializer instead.
    RUBY
  end

  it 'registers an offense when using `respond_with` with a multiline hash' do
    expect_offense <<~RUBY
      respond_with({
      ^^^^^^^^^^^^^^ Don\'t use `respond_with` with a hash. Use a value and serializer instead.
        data: @foo,
        message: "bar"
      })
    RUBY
  end

  it 'registers an offense when using `respond_with` with a hash from variable' do
    expect_offense <<~RUBY
      my_hash = { data: @foo, message: "bar" }
      respond_with my_hash
      ^^^^^^^^^^^^^^^^^^^^ Don\'t use `respond_with` with a hash. Use a value and serializer instead.
    RUBY
  end

  it 'does not register an offense when using `respond_with` with a record' do
    expect_no_offenses <<~RUBY
      respond_with @foo
    RUBY
  end

  it 'does not register an offense when using `respond_with` with a record from a variable' do
    expect_no_offenses <<~RUBY
      my_foo = @foo
      respond_with my_foo
    RUBY
  end

  it 'does not register an offense when using `respond_with` with a value' do
    expect_no_offenses <<~RUBY
      respond_with(Resource.new(blog.id, blog.title))
    RUBY
  end

  it 'does not register an offense when using `respond_with` with a value from a variable' do
    expect_no_offenses <<~RUBY
      my_resource = Resource.new(blog.id, blog.title)
      respond_with(my_resource)
    RUBY
  end
end
