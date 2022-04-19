# frozen_string_literal: true

module RuboCop
  module Cop
    module Platanus
      # Usage of PowerTypes::Command is no longer recommended. Rails
      # ApplicationJob should be used instead.
      #
      # @example
      #
      #   # bad
      #   class ExecuteSomeAction < PowerTypes::Command.new(:foo, :bar)
      #     def perform
      #       # Command code goes here
      #     end
      #    end
      #
      #   # good
      #   class GuestsCleanupJob < ApplicationJob
      #     def perform
      #       # Job code goes here
      #     end
      #   end
      #
      class NoCommand < Base
        MSG = 'Use `ApplicationJob` instead of `PowerTypes::Command`.'

        # @!method uses_powertypes_command?(node)
        def_node_matcher :uses_powertypes_command?, <<~PATTERN
          (class _ (send (const (const _ :PowerTypes) :Command) :new ...) _)
        PATTERN

        def on_class(node)
          return unless uses_powertypes_command?(node)

          add_offense(node)
        end
      end
    end
  end
end
