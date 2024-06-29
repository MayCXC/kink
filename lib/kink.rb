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
      v = y
      while true
        v = yield(*v)
        break v unless v.is_a? NextArgs
        next unless v.length > 0
        h,*t = v
        next h unless v.length > 1
        next h,*t
      end
    rescue StopIteration => e
      e.result
    end
  end
end
