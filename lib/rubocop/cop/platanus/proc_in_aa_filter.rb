# frozen_string_literal: true

module RuboCop
  module Cop
    module Platanus
      # Collections in filters should be lambdas, procs or Proc.new, because in production
      # ActiveAdmin classes are loaded before the database is ready.
      #
      #
      # @example
      #
      #   # bad
      #   filter :email, collection: User.all
      #
      #   # good
      #   filter :email, collection: -> { User.all }
      #
      #   # good
      #   filter :email, collection: lambda { User.all }
      #
      #   # good
      #   filter :email, collection: proc { User.all }
      #
      #   # good
      #   filter :email, collection: Proc.new { User.all }
      #
      class ProcInAAFilter < Base
        MSG = 'Collection should be lambda/proc/Proc.new'

        def_node_matcher :get_filter_args, <<~PATTERN
          (send nil? :filter $...)
        PATTERN

        def_node_matcher :get_collection_value_from_kwargs, <<~PATTERN
          (hash <(pair (sym :collection) $_) ...>)
        PATTERN

        def_node_matcher :lambda?, <<~PATTERN
          (block (send nil? :lambda) ...)
        PATTERN

        def_node_matcher :proc_new?, <<~PATTERN
          (block (send (const nil? :Proc) :new) ...)
        PATTERN

        def_node_matcher :proc?, <<~PATTERN
          (block (send nil? :proc) ...)
        PATTERN

        def on_send(node)
          filter_args = get_filter_args(node)

          return unless filter_args

          _, kwargs = filter_args

          return unless kwargs

          collection_value = get_collection_value_from_kwargs(kwargs)

          return unless collection_value

          is_offense = !lambda?(collection_value) &&
            !proc_new?(collection_value) &&
            !proc?(collection_value)

          add_offense(collection_value) if is_offense
        end
      end
    end
  end
end
