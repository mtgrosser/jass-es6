module Jass::ES6::BundleProcessor
  class << self
    def call(input)
      env, filename = input.fetch(:environment), input.fetch(:filename)
      dependencies = Set.new(input.fetch(:metadata).fetch(:dependencies))
      globals = input.fetch(:metadata).fetch(:globals, {})
      bundle_root = Pathname.new(filename).dirname
      bundle = Jass::ES6::Compiler.bundle(filename, input_options: { external: globals.keys }, output_options: { globals: globals })
      dependencies += bundle.fetch('map').fetch('sources').map { |dep| Sprockets::URIUtils.build_file_digest_uri(bundle_root.join(dep).to_s) }
      
      { data: bundle.fetch('code'),
        dependencies: dependencies,
        map: bundle.fetch('map') }
    end
  end
end
