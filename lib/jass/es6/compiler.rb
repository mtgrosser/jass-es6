class Jass::ES6::Compiler < Nodo::Core
  require Buble: 'buble',
          NodentCompiler: 'nodent-compiler',
          Rollup: 'rollup',
          commonjs: '@rollup/plugin-commonjs',
          nodeResolve: '@rollup/plugin-node-resolve'
  
  const :PLUGINS, []
  
  class << self
    attr_accessor :input_options, :plugins
    
    def prepend_plugin(package, name, arguments = nil)
      plugins.unshift(Jass::ES6::Plugin.new(name, arguments))
      require name => package
    end
    
    def append_plugin(package, name, arguments = nil)
      plugins.push(Jass::ES6::Plugin.new(name, arguments))
      require name => package
    end
  end
  
  self.input_options = {}
  self.plugins = []
  
  script do
    <<~JS
      const Nodent = new NodentCompiler;
      #{plugins.map(&:to_js).join}
    JS
  end

  function :nodent, <<~'JS'
    (src, filename) => {
      return Nodent.compile(src, filename,
        { es6target: true,
          sourcemap: false,
          parser: {
            sourceType: 'script',
            ecmaVersion: 9
          },
          promises: true,
          noRuntime: true }).code;
    }
  JS

  function :buble, <<~'JS'
    (src) => {
      return Buble.transform(src,
        { transforms: { dangerousForOf: true },
          objectAssign: 'Object.assign' }).code;
    }
  JS
  
  # Compile ES6 without imports: buble(nodent(src))
  function :compile, code: '(src, filename) => buble(nodent(src, filename))'

  # Build bundle with imports: buble(rollup(nodent(src)))
  function :js_bundle, <<~'JS'
    (entry, inputOptions, outputOptions) => {
      inputOptions = inputOptions || {};
      outputOptions = outputOptions || {};
      const inputDefaultOptions = {
        input: entry,
        plugins: [
          ...PLUGINS,
          nodeResolve.nodeResolve({ moduleDirectories: [process.env.NODE_PATH] }),
          commonjs()
        ]
      };
      // TODO: throw error unless moduleDirectories
      Object.assign(outputOptions,
        { format: 'iife',
          sourcemap: true,
          exports: 'none'
        }
      );
      const io = { ...inputDefaultOptions, ...inputOptions };
      nodo.debug(JSON.stringify(io));
      nodo.debug(JSON.stringify(outputOptions));
      return Rollup.rollup(io)
        .then(bundle => bundle.generate(outputOptions))
        .then(bundle => {
          const output = bundle.output[0];
          return { code: compile(output.code), map: output.map };
      });
    }
  JS
  
  class_function def bundle(entry, input_options: self.class.input_options, output_options: {})
    js_bundle(entry, input_options, output_options)
  end
  
  # Get vendor library versions
  function :versions, <<~'JS'
    () => {
      return {  buble: Buble.VERSION,
                rollup: Rollup.VERSION,
                nodent: Nodent.version };
    }
  JS

end
