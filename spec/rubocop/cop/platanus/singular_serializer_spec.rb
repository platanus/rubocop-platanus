# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Platanus::SingularSerializer, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using regular plural resource name' do
    expect_offense <<~RUBY
      class UsersSerializer < ActiveModel::Serializer
            ^^^^^^^^^^^^^^^ Serializer name should be singular. Prefer `UserSerializer`.
      end
    RUBY

    expect_correction <<~RUBY
      class UserSerializer < ActiveModel::Serializer
      end
    RUBY
  end

  it 'registers an offense when using irregular plural resource name' do
    expect_offense <<~RUBY
      class DressesSerializer < ActiveModel::Serializer
            ^^^^^^^^^^^^^^^^^ Serializer name should be singular. Prefer `DressSerializer`.
      end
    RUBY

    expect_correction <<~RUBY
      class DressSerializer < ActiveModel::Serializer
      end
    RUBY
  end

  it 'registers an offense when using namespaced plural resource name' do
    expect_offense <<~RUBY
      class Api::v1::UsersSerializer < Api::V1::BaseSerializer
            ^^^^^^^^^^^^^^^^^^^^^^^^ Serializer name should be singular. Prefer `Api::v1::UserSerializer`.
      end
    RUBY

    expect_correction <<~RUBY
      class Api::v1::UserSerializer < Api::V1::BaseSerializer
      end
    RUBY
  end

  it 'does not register an offense when using singular resource name' do
    expect_no_offenses <<~RUBY
      class UserSerializer < ActiveModel::Serializer
      end
    RUBY

    expect_no_offenses <<~RUBY
      class DressSerializer < ActiveModel::Serializer
      end
    RUBY

    expect_no_offenses <<~RUBY
      class Api::v1::UserSerializer < Api::V1::BaseSerializer
      end
    RUBY
  end
end
