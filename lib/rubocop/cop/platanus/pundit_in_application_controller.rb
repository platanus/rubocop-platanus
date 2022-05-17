# frozen_string_literal: true

module RuboCop
  module Cop
    module Platanus
      # Pundit should not be included in specific controllers. Prefer
      # including it in the ApplicationController instead.
      #
      # @example
      #   # bad
      #   class ApplicationController < ActionController::Base
      #   end
      #
      #   class FooController < ApplicationController
      #     include Pundit
      #   end
      #
      #   # bad
      #   class ApplicationController < ActionController::Base
      #   end
      #
      #   class FooController < ApplicationController
      #     include Pundit::Authorization
      #   end
      #
      #   # good
      #   class ApplicationController < ActionController::Base
      #     include Pundit
      #   end
      #
      #   class FooController < ApplicationController
      #   end
      #
      #   # good
      #   class ApplicationController < ActionController::Base
      #     include Pundit::Authorization
      #   end
      #
      #   class FooController < ApplicationController
      #   end
      #
      class PunditInApplicationController < Base
        MSG = '`Pundit` should be included only in the `ApplicationController`.'

        def_node_matcher :get_include_pundit_node, <<~PATTERN
          (class _ _ `$(
            send
            nil?
            :include
            (const {nil? | (const _ :Pundit)} {:Pundit | :Authorization})
          ))
        PATTERN

        def_node_matcher :application_controller?, <<~PATTERN
          (class (const nil? :ApplicationController) `(const (const nil? :ActionController) :Base) ...)
        PATTERN

        def on_class(node)
          pundit_include_node = get_include_pundit_node(node)
          return unless pundit_include_node && !application_controller?(node)

          add_offense(pundit_include_node)
        end
      end
    end
  end
end
