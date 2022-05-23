# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Platanus::NoFlashInApi, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `flash`' do
    expect_offense <<~RUBY
      class Foo
        def bar
          flash[:notice] = 'Foo'
          ^^^^^^^^^^^^^^^^^^^^^^ Don't use `flash` in API controllers.
          flash[:danger] = 'Bar'
          ^^^^^^^^^^^^^^^^^^^^^^ Don't use `flash` in API controllers.
          flash['success'] = 'Baz'
          ^^^^^^^^^^^^^^^^^^^^^^^^ Don't use `flash` in API controllers.
          redirect_to root_path
        end
      end
    RUBY

    expect_correction <<~RUBY
      class Foo
        def bar
        #{'  '}
        #{'  '}
        #{'  '}
          redirect_to root_path
        end
      end
    RUBY
  end

  it 'does not register an offense when not using `flash`' do
    expect_no_offenses <<~RUBY
      class Foo
        def bar
          redirect_to root_path
        end
      end
    RUBY
  end
end
