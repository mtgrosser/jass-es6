class Jass::ES6::Compiler < Nodo::Core
  require Buble: 'buble',
          NodentCompiler: 'nodent-compiler',
          Rollup: 'rollup',
          nodeResolve: 'rollup-plugin-node-resolve',
          commonjs: 'rollup-plugin-commonjs'
  
  script <<~'JS'
    const Nodent = new NodentCompiler;
  JS
    
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
    (entry, moduleDirectories, inputOptions, outputOptions) {
      inputOptions = inputOptions || {};
      outputOptions = outputOptions || {};
      const inputDefaultOptions = {
        input: entry,
        treeshake: false,
        plugins: [
          nodeResolve({ customResolveOptions: { moduleDirectory: moduleDirectories }}),
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
      const promise = Rollup.rollup({ ...inputDefaultOptions, ...inputOptions })
          .then(bundle => bundle.generate(outputOptions))
          .then(bundle => { return { code: send('compile', bundle.code), map: bundle.map }; });
      return promise;
    }
  JS
  
  def bundle(entry, input_options: Jass::ES6.input_options, output_options: {})
    js_bundle(entry, self.class.node_paths, input_options, output_options)
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
