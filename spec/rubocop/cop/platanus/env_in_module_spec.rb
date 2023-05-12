# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Platanus::EnvInModule, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `ENV.fetch`' do
    expect_offense <<~RUBY
      class Foo
        BAR = ENV.fetch('BAR')
              ^^^^^^^^^^^^^^^^ Use dedicated module for environment variables retrieval instead.

        def foo_method
          BAR
        end
      end
    RUBY
  end

  it 'registers an offense when using `ENV[]`' do
    expect_offense <<~RUBY
      class Foo
        BAR = ENV['BAR']
              ^^^^^^^^^^ Use dedicated module for environment variables retrieval instead.

        def foo_method
          BAR
        end
      end
    RUBY
  end

  it 'does not register an offense when not using `ENV.fetch` or `ENV`' do
    expect_no_offenses <<~RUBY
      class Foo
        def foo_method
          EnviromentVariables.bar
        end
      end
    RUBY
  end
end
