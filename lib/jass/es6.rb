require 'set'
require 'pathname'
require 'open3'

require 'nodo'

require_relative 'es6/version'
require_relative 'es6/plugin'
require_relative 'es6/compiler'

begin
  require 'sprockets'
rescue LoadError
  # Sprockets not available
end

if defined?(Sprockets)
  require_relative 'es6/global_directive_processor'
  require_relative 'es6/processor'
  require_relative 'es6/bundle_processor'

  Sprockets.register_mime_type 'text/ecmascript-6', extensions: %w[.jass], charset: :unicode
  Sprockets.register_transformer 'text/ecmascript-6', 'application/javascript', Jass::ES6::BundleProcessor
  Sprockets.register_preprocessor 'text/ecmascript-6', Jass::ES6::GlobalDirectiveProcessor
end
