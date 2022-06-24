# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module RuboCop
  module Cop
    module Platanus
      # Serializers must be named with a singular resource name.
      #
      # @example
      # # bad
      # class UsersSerializer < ActiveModel::Serializer
      # end
      #
      # # good
      # class UserSerializer < ActiveModel::Serializer
      # end
      #
      class SingularSerializer < Base
        extend AutoCorrector
        MSG = 'Serializer name should be singular. Prefer `%<resource_name>s`.'

        def_node_matcher :serializer_definition?, <<~PATTERN
          (class $_ _ _)
        PATTERN

        def on_class(node)
          class_name_node = serializer_definition?(node)
          class_name = class_name_node&.source

          return unless class_name && serializer?(class_name) && resource_plural?(class_name)

          singularized_class = singularize(class_name)
          return unless singularized_class

          add_offense(class_name_node, message: message(singularized_class)) do |corrector|
            corrector.replace(class_name_node, singularized_class)
          end
        end

        private

        def serializer?(class_name)
          class_name.match(/(::)?[a-zA-Z]\w*Serializer$/)
        end

        def resource_plural?(class_name)
          name_parts = class_name.split('::')
          resource = name_parts.last.sub(/Serializer$/, '')

          resource == resource.pluralize
        end

        def singularize(class_name)
          name_parts = class_name.split('::')
          resource = name_parts.last.sub(/Serializer$/, '')

          name_parts[-1] = "#{resource.singularize}Serializer"

          name_parts.join('::')
        end

        def message(singular_name)
          format(MSG, resource_name: singular_name)
        end
      end
    end
  end
end
