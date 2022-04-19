# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Platanus::NoCommand, :config do
  it 'registers an offense when using `PowerTypes::Command`' do
    expect_offense(<<~RUBY)
      class MyCommand < PowerTypes::Command.new(:bar)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `ApplicationJob` instead of `PowerTypes::Command`.
      end
    RUBY
  end

  it 'does not register an offense when not using `PowerTypes::Command`' do
    expect_no_offenses(<<~RUBY)
      class MyCommand < ApplicationJob
      end

      class MyClass
      end
    RUBY
  end
end
