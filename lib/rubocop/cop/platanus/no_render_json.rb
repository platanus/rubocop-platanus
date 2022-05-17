# frozen_string_literal: true

module RuboCop
  module Cop
    module Platanus
      # `render json:` shouldn't be used in controllers because it'll skip
      #  the use of ApiResponder and serializers. Use `respond_with` instead.
      #
      # @example
      #
      #   # bad
      #   render json: { data: @foo }
      #
      #   # bad
      #   class Api::Internal::ResourcesController < Api::Internal::BaseController
      #     def show
      #       authorization_url = google_srv.generate_authorization_url
      #       respond_with({ authorization_url: authorization_url })
      #     end
      #   end
      #
      #   # bad
      #   class Api::Internal::ResourcesController < Api::Internal::BaseController
      #     def show
      #       hash_response = { data: @foo }
      #       respond_with hash_response
      #     end
      #   end
      #
      #   # good
      #   respond_with @foo
      #
      #   # good
      #   # values/resource.rb
      #   class Resource
      #     include ActiveModel::Serialization
      #
      #     attr_accessor :id, :name
      #
      #     def initialize(id, name)
      #       @id = id
      #       @name = name
      #     end
      #   end
      #
      #   # serializers/resource_serializer.rb
      #   class Api::Internal::ResourceSerializer < ActiveModel::Serializer
      #     type :resource
      #     attributes(
      #       :id,
      #       :name
      #     )
      #   end
      #
      #   # controllers/api/internal_resources/resources_controller.rb
      #   class Api::Internal::ResourcesController < Api::Internal::BaseController
      #     def show
      #       respond_with(Resource.new(blog.id, blog.title))
      #     end
      #   end
      #
      class NoRenderJson < Base
        RENDER_JSON_MSG = 'Use `respond_with` instead of `render json:`.'
        RENDER_HASH_MSG =
          'Don\'t use `respond_with` with a hash. Use a value and serializer instead.'

        RESTRICT_ON_SEND = %i[render respond_with].freeze

        # Matches if render is called with json
        def_node_matcher :render_json?, <<~PATTERN
          (send nil? :render (hash (pair (sym :json) ...) ...))
        PATTERN

        # Captures the argument of respond_with
        def_node_matcher :respond_with, <<~PATTERN
          (send nil? :respond_with $_)
        PATTERN

        # Matches if node is hash
        def_node_matcher :is_hash?, '(hash ...)'

        # Captures the variable named of a used variable
        def_node_matcher :var_name, '(lvar $_)'

        def on_send(node)
          if render_json?(node)
            add_offense(node, message: RENDER_JSON_MSG)
          elsif respond_with_hash?(node)
            add_offense(node, message: RENDER_HASH_MSG)
          end
        end

        # Determines if the node corresponds to a call of respond_with
        # with a hash as it's argument.
        def respond_with_hash?(node)
          hash_node = respond_with(node)
          return true if is_hash?(hash_node)

          return false unless hash_node.variable?

          var_name = var_name(hash_node)
          return false if var_name.nil?

          var_is_hash?(node, var_name)
        end

        # Determines if a variable name corresponds to a hash within it's
        # most immediate scope.
        def var_is_hash?(node, var_name)
          scope = node.parent
          return false unless scope

          pattern = "`(lvasgn :#{var_name} (hash ...))"
          matcher = RuboCop::AST::NodePattern.new(pattern)

          matcher.match(scope)
        end
      end
    end
  end
end
