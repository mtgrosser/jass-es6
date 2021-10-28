require 'set'
require 'pathname'
require 'open3'

module Jass::ES6
  class << self
    attr_accessor :input_options

    def input_options
      @input_options || {}
    end
  end
end

require 'es6/version'
require 'es6/compiler'

begin
  require 'sprockets'
rescue LoadError
  # Sprockets not available
end

if defined?(Sprockets)
  require 'es6/global_directive_processor'
  require 'es6/processor'
  require 'es6/bundle_processor'

  Sprockets.register_mime_type 'text/ecmascript-6', extensions: %w[.jass], charset: :unicode
  Sprockets.register_transformer 'text/ecmascript-6', 'application/javascript', Jass::BundleProcessor
  Sprockets.register_preprocessor 'text/ecmascript-6', Jass::GlobalDirectiveProcessor
end
