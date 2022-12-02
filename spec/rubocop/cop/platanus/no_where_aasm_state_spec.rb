# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Platanus::NoWhereAasmState, :config do
  let(:config) { RuboCop::Config.new }
  it 'registers an offense when using `.where(aasm_state: ...)` on a class' do
    expect_offense(<<~RUBY)
      User.where(aasm_state: 'active')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `where` with `aasm_state` column. Use `Model.state` instead.
    RUBY
  end

  it 'registers an offense when using `.where(aasm_state: ...)` not on a class' do
    expect_offense(<<~RUBY)
      where(aasm_state: 'active')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `where` with `aasm_state` column. Use `Model.state` instead.
    RUBY
  end

  it 'registers an offense when using `.where(aasm_state: ...)` with other columns' do
    expect_offense(<<~RUBY)
      where(first_column: '1', aasm_state: 'active', second_column: 2)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `where` with `aasm_state` column. Use `Model.state` instead.
    RUBY
  end

  it 'does not register an offense when using aasm state scope' do
    expect_no_offenses(<<~RUBY)
      User.active
    RUBY
  end

  it 'does not register an offense when using `.where` without `aasm_state`' do
    expect_no_offenses(<<~RUBY)
      User.where(name: 'John')
    RUBY

    expect_no_offenses(<<~RUBY)
      where(name: 'John')
    RUBY
  end
end
