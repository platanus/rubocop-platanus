# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Platanus::PunditInApplicationController, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when including `Pundit` out of `ApplicationController`' do
    expect_offense <<~RUBY
      class FooController < BarController::Base
        include Baz
        include Pundit::Authorization
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `Pundit` should be included only in the `ApplicationController`.
        include Qux

        def main
        end
      end
    RUBY

    expect_offense <<~RUBY
      class FooController < BarController::Base
        include Baz
        include Pundit
        ^^^^^^^^^^^^^^ `Pundit` should be included only in the `ApplicationController`.
        include Qux

        def main
        end
      end
    RUBY
  end

  it 'does not register when including `Pundit` in `ApplicationController`' do
    expect_no_offenses <<~RUBY
      class ApplicationController < ActionController::Base
        include Baz
        include Pundit::Authorization
        include Qux

        def main
        end
      end
    RUBY
  end

  it 'does not register when not including `Pundit`' do
    expect_no_offenses <<~RUBY
      class FooController < BarController::Base
        include Baz
        include Qux

        def main
        end
      end
    RUBY
  end
end
