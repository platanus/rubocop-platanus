# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Platanus::NoEnumerize, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `enumerize`' do
    expect_offense <<~RUBY
      class Foo
        extend Enumerize
        ^^^^^^^^^^^^^^^^ Use Rails `enum` instead of `enumerize`.

        enumerize :bar, in: [:foo, :bar]
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use Rails `enum` instead of `enumerize`.
      end
    RUBY

    expect_correction <<~RUBY
      class Foo
      #{'  '}

        enum bar: { foo: 0, bar: 1 }
      end
    RUBY
  end

  it 'registers an offense when using `enumerize` with more hash parameters' do
    expect_offense <<~RUBY
      class Foo
        extend Enumerize
        ^^^^^^^^^^^^^^^^ Use Rails `enum` instead of `enumerize`.

        enumerize :bar, in: [:foo, :bar], default: :foo
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use Rails `enum` instead of `enumerize`.
      end
    RUBY

    expect_correction <<~RUBY
      class Foo
      #{'  '}

        enum bar: { foo: 0, bar: 1 }
      end
    RUBY
  end

  it 'registers an offense when using `enumerize` with hash parameters in any order' do
    expect_offense <<~RUBY
      class Foo
        extend Enumerize
        ^^^^^^^^^^^^^^^^ Use Rails `enum` instead of `enumerize`.

        enumerize :bar, default: :foo, in: [:foo, :bar]
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use Rails `enum` instead of `enumerize`.
      end
    RUBY

    expect_correction <<~RUBY
      class Foo
      #{'  '}

        enum bar: { foo: 0, bar: 1 }
      end
    RUBY
  end

  it 'does not register an offense when using Rails `enum`' do
    expect_no_offenses <<~RUBY
      class Foo
        enum bar: [:foo, :bar]
      end
    RUBY
  end
end
