# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Platanus::ProcInAAFilter, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when not using lambda/proc/Proc.new' do
    expect_offense(<<~RUBY)
      ActiveAdmin.register User do
        permit_params :email, :password, :password_confirmation

        filter :email, other_kwarg: 1, collection: User.all
                                                   ^^^^^^^^ Collection should be lambda/proc/Proc.new
      end
    RUBY
  end

  it 'does not register an offense when using lambda' do
    expect_no_offenses(<<~RUBY)
      ActiveAdmin.register User do
        permit_params :email, :password, :password_confirmation

        filter :email, collection: lambda { User.all }
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      ActiveAdmin.register User do
        permit_params :email, :password, :password_confirmation

        filter :email, collection: -> { User.all }
      end
    RUBY
  end

  it 'does not register an offense when using proc' do
    expect_no_offenses(<<~RUBY)
      ActiveAdmin.register User do
        permit_params :email, :password, :password_confirmation

        filter :email, collection: proc { User.all }
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      ActiveAdmin.register User do
        permit_params :email, :password, :password_confirmation

        filter :email, collection: Proc.new { User.all }
      end
    RUBY
  end

  it 'does not register an offense when collection is not defined' do
    expect_no_offenses(<<~RUBY)
      ActiveAdmin.register User do
        permit_params :email, :password, :password_confirmation

        filter :email, other_kwarg: 1
      end
    RUBY
  end

  it 'does not register an offense on a collection outside of filter' do
    expect_no_offenses(<<~RUBY)
      ActiveAdmin.register User do
        permit_params :email, :password, :password_confirmation

        form do |f|
          f.inputs do
            f.select :email, collection: User.all
          end
        end
      end
    RUBY
  end
end
