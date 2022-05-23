# frozen_string_literal: true

module RuboCop
  module Cop
    module Platanus
      # Prefer usage of Rails `enum` instead of `Enumerize`
      #
      # @safety
      #   This cop's autocorrection will remove any lines using `extend Enumerize`
      #   and `enumerize :foo, in: [:bar, :baz]` within a file in app/models.
      #   There might be a case where using `enumerize` might be the intended behavior.
      #
      # @example
      #   # bad
      #   class Foo
      #     extend Enumerize
      #     enumerize :bar, in: [:foo, :bar]
      #   end
      #
      #   # good
      #   class Foo
      #     enum bar: { foo: 0, bar: 1 }
      #   end
      #
      class NoEnumerize < Base
        extend AutoCorrector
        MSG = 'Use Rails `enum` instead of `enumerize`.'

        # Detect if class extends `Enumerize`
        def_node_matcher :extend_enumerize?, <<~PATTERN
          (send nil? :extend (const nil? :Enumerize) ...)
        PATTERN

        # Returns the name and `in:` arguments of the enumerize call
        def_node_matcher :get_enumerize_args, <<~PATTERN
          (send nil? :enumerize (sym $_) (
            hash
            <
              (pair (sym :in) (array $...))
              ...
            >
          ))
        PATTERN

        def on_send(node)
          on_extend_enumerize(node)
          on_enumerize(node)
        end

        private

        # Detects if class extends `Enumerize`
        def on_extend_enumerize(node)
          return unless extend_enumerize?(node)

          add_offense(node) do |corrector|
            corrector.remove(node)
          end
        end

        # Detects if class uses `enumerize`. If so, it corrects the code.
        def on_enumerize(node)
          enumerize_args = get_enumerize_args(node)
          return unless enumerize_args

          name, args = enumerize_args
          args = args.map(&:value)

          add_offense(node) do |corrector|
            corrector.replace(node, enumerize_correction(name, args))
          end
        end

        # Returns the corrected code for `enumerize`
        def enumerize_correction(name, args)
          args_string = args.map.with_index do |arg, i|
            "#{arg}: #{i}"
          end.join(', ')

          "enum #{name}: { #{args_string} }"
        end
      end
    end
  end
end
