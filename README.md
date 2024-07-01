# kink.rb

[![Gem Version](https://badge.fury.io/rb/kink.svg)](https://badge.fury.io/rb/kink)

`kink` is an alternative `loop` that only repeats when you tell it to with `redo`:

```ruby
require "kink"
include Kink

kink do
  print "Input: "
  line = gets
  if !line or line !~ /^\d+\n?$/
    puts "Please enter a base 10 number with no separators or spaces."
    redo
  end
  puts "Got input: #{line}"
  # ...
end
```

otherwise, a `kink` will end on its own, with no need for a `break` statement:

```ruby
kink do
  print "This message only prints once: "
end
puts "as promised."
```

a `kink` can still use both `break` and `next` statements. either can end the loop, and either can an accept arguments that supply the result of the block. if `next` accepts a single argument returned by `kink_next()`, the `kink` repeats:

```ruby
i=0
puts i

b=kink do
        i += 1
        puts i
        next kink_next() if i == 3
        puts "i is not 3"
        redo if i < 5
        break "broken" if i == 5
        "otherwise this would be b"
end
puts b
```

```
0
1
i is not 3
2
i is not 3
3
4
i is not 3
5
i is not 3
broken
```

arguments can also be supplied to `kink(*args)`, where they are passed through `do |*args|`, and resupplied by `next kink_next(*args)`:

```ruby
c=kink(-3,0,12,0) do |x,y,z,t|
        puts "(x,y,z)(#{t}) = (#{x},#{y},#{z})"
        d=(x-y).abs2 + (y-z).abs2 + (z-x).abs2
        puts "d(#{t}) = #{d}"
        next kink_next((y+z)/2, (x+z)/2, (x+y)/2, t.succ) unless d<1
        "d(#{t}) < 1"
end
puts c
```

```
(x,y,z)(0) = (-3,0,12)
d(0) = 378
(x,y,z)(1) = (6,4,-2)
d(1) = 104
(x,y,z)(2) = (1,2,5)
d(2) = 26
(x,y,z)(3) = (3,3,1)
d(3) = 8
(x,y,z)(4) = (2,2,3)
d(4) = 2
(x,y,z)(5) = (2,2,2)
d(5) = 0
d(5) < 1
```

a method similar to `Enumerator.produce` is also provided by the name of `kink_produce`:

```ruby
z=kink_produce(5) do |x|
  if x.even?
    puts "#{x} is even"
    kink_next(x/2)
  else
    puts "#{x} is odd"
    kink_next(3*x + 1)
  end
end

z.lazy.take_while{|x| (x > 1).tap{|p| puts "#{x} is #{p ? "greater than" : "equal to"} one"}}
  .first(1000000)
  .then{|xxx| puts xxx.inspect}
```

```
5 is greater than one
5 is odd
16 is greater than one
16 is even
8 is greater than one
8 is even
4 is greater than one
4 is even
2 is greater than one
2 is even
1 is equal to one
[5, 16, 8, 4, 2]
```

this provides a unified syntax to mix and match `for`, `while`, `do while`, and `until` semantics all day long, in a way that still feels familiar to the `loop` connoisseur. like `Enumerator.produce`, both methods implement a control structure similar to optimized tail recursion directly, where `next kink_next(*args)` has the same semantics as an optimized tail call. now go work out some kinks :^)
