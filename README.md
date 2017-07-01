# Static Array/Dynamic Array/Ring Buffer

I wanted to see how Ruby's Dynamic Array worked behind the scenes, so I first created a Static Array
that only had get and set methods, as well as no resizing capabilities.

Based on my Static Array, I created a Dynamic Array that could push and pop in O(1) time, and shift and unshift
in O(n) time. I wanted to improve time complexity for shift and unshift operations to constant time, so I created a Ring Buffer.


## Static Array

```ruby
class StaticArray
  def initialize(length)
    @store = Array.new(length)
  end

  # O(1)
  def [](index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
  end

  protected
  attr_accessor :store

end
```


## Dynamic Array

I used a Static Array as my main data structure. Because Static Arrays are statically sized upon initialization, I needed a way to change the size if the array became too big. With the resize! operation, I
would create a new Static Array twice the size of the original and move each element from the old array to the new array. This costly operation takes O(n) time, but in the long run, the overall operation of adding new elements such as "push" averages out to be O(1) ammortized.

```ruby
def resize!
  old_array = @store
  old_length = capacity
  @store = StaticArray.new(capacity * 2)
  @capacity *=2
  i = 0
  while i < old_length
    @store[i] = old_array[i]
    i += 1
  end
end
```

## Ring Buffer

Although resize! helps the "push" operation to be O(1), shift and unshift are still O(n), because each element in the array needs to move over once to the left or right.

The Ring Buffer can be thought of as a circular data structure. When you unshift an item, instead of adding the new item to position 0 of the array, you add it to the last position of the array. Then, you reposition the "beginning" of the array to be the last position. This can be accomplished with the modulo operation.

```ruby
def unshift(val)
  resize! if @length >= @capacity
  @start_idx = (@start_idx - 1) % @capacity
  #this operation puts the starting position at the
  #end of the new resized array, or to the left one space.
  @length+=1
  self[0] = val
end
```

Each time you unshift, you can think of shifting the starting index counterclockwise, or to the left. Each time you shift, it's moving the starting index clockwise, or to the right.

```ruby
def shift
  raise "index out of bounds" if @length==0
  target = self[0]
  self[0] = nil
  @start_idx = (@start_idx + 1) % @capacity
  #this operation shifts the start_idx to the right one space.
  @length -=1
  target
end
```

Now shift and unshift are both O(1) ammortized operations (ammortized because of resize!).
