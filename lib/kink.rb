module Kink
  class NextArgs
    include Enumerable

    def initialize(*args)
      @args=args
    end

    def each(&block)
      @args.each(&block)
    end
  end

  module_function

  def kink_next(*args)
    NextArgs.new(*args)
  end

  def kink(*y)
    unless block_given?
      return enum_for(:kink,*y) { 1 }
    end

    begin
      v = kink_next(*y)
      while v.is_a? NextArgs
        v = yield *v
      end
      v
    rescue StopIteration => e
      e.result
    end
  end

  def kink_produce(*y)
    unless block_given?
      raise ArgumentError.new("no block given")
    end

    Enumerator.new do |yielder|
      yielder.yield(*y) unless y.empty?
      v = kink_next(*y)
      while v.is_a? NextArgs
        v = yield *v
        yielder.yield(*v)
      end
    end
  end
end
