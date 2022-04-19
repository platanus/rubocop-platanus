# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/platanus'
require_relative 'rubocop/platanus/version'
require_relative 'rubocop/platanus/inject'

RuboCop::Platanus::Inject.defaults!

require_relative 'rubocop/cop/platanus_cops'
