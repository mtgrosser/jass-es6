class Jass::ES6Processor
  class << self
    def call(input)
      { data: Jass::ES6Compiler.compile(input[:data]) }
    end
  end
end
