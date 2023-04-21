# frozen_string_literal: true

module RuboCop
  module Cop
    module Platanus
      # Environment variables should not be retrieved directly. Prefer retrieving them in a
      # dedicated module. This centralizes their location, enhances their functionality and makes
      # them easier to stub.
      #
      # @example
      #
      #   # bad
      #   class Foo
      #     BAR = ENV.fetch('BAR')
      #
      #     def foo_method
      #       BAR
      #     end
      #   end
      #
      #   # bad
      #   class Foo
      #     BAR = ENV['BAR']
      #
      #     def foo_method
      #       BAR
      #     end
      #   end
      #
      #   # good
      #   module EnvironmentVariables
      #     extend self
      #
      #     BAR = ENV.fetch('BAR')
      #
      #     def bar
      #       BAR
      #     end
      #   end
      #
      #   class Foo
      #     def foo_method
      #       EnvironmentVariables.bar
      #     end
      #   end
      #
      class EnvInModule < Base
        MSG = 'Use dedicated module for environment variables retrieval instead.'

        # @!method env_retrieve?(node)
        def_node_matcher :env_retrieve?, <<~PATTERN
          (send (const nil? :ENV) { :fetch | :[] } ...)
        PATTERN

        def on_send(node)
          return unless env_retrieve?(node)

          add_offense(node)
        end
      end
    end
  end
end
