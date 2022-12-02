# frozen_string_literal: true

module RuboCop
  module Cop
    module Platanus
      # This cop checks for usage of `where(aasm_state: ...)` in models.
      # This is not recommended because it may lead to silent errors.
      # It should be replaced by the scopes provided by Rails enum.
      #
      #   # bad
      #   User.where(aasm_state: 'active')
      #
      #   # good
      #   User.active
      #
      class NoWhereAasmState < Base
        MSG = 'Do not use `where` with `aasm_state` column. Use `Model.state` instead.'

        def_node_matcher :aasm_state_hash?, <<~PATTERN
          (hash <(pair (sym :aasm_state) $_) ...>)
        PATTERN

        def_node_matcher :where_with_aasm_state?, <<~PATTERN
          (send _ :where <#aasm_state_hash? ...>)
        PATTERN

        def on_send(node)
          return unless where_with_aasm_state?(node)

          add_offense(node)
        end
      end
    end
  end
end
