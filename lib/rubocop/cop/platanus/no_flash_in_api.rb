# frozen_string_literal: true

module RuboCop
  module Cop
    module Platanus
      # Flash shouldn't be used in API controllers.
      #
      # @safety
      #   Auto correction will delete any lines using `flash[:type] = 'foo'`. There might be cases
      #   where using flash might be the intended behavior.
      #
      # @example
      #
      #   # bad
      #   class Api::Internal::ResourcesController < Api::Internal::BaseController
      #     def show
      #       flash[:notice] = 'Foo'
      #       ...
      #     end
      #   end
      #
      #   # good
      #   class Api::Internal::ResourcesController < Api::Internal::BaseController
      #     def show
      #       ...
      #     end
      #   end
      #
      class NoFlashInApi < Base
        extend AutoCorrector

        MSG = "Don't use `flash` in API controllers."

        def_node_matcher :flash?, <<~PATTERN
          (send (send nil? :flash) :[]= ...)
        PATTERN

        def on_send(node)
          return unless flash?(node)

          add_offense(node) do |corrector|
            corrector.remove(node)
          end
        end
      end
    end
  end
end
