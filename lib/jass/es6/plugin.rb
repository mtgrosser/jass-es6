class Jass::ES6::Plugin
  attr_reader :name, :arguments

  def initialize(name, arguments = nil)
    @name, @arguments = name, arguments
  end
    
  def to_js
    args = arguments.respond_to?(:call) ? arguments.call : arguments
    "PLUGINS.push(#{name}(#{args}));\n"
  end
end
