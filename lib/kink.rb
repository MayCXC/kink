module Kink
  class NextArgs < Array
  end

  module_function

  def kink_next(*args)
    NextArgs[*args]
  end

  def kink(*y)
    unless block_given?
      return enum_for(:kink) { 1 }
    end

    begin
      v = NextArgs[*y]
      while v.is_a? NextArgs
        v = yield *v
      end
      v
    rescue StopIteration => e
      e.result
    end
  end
end
