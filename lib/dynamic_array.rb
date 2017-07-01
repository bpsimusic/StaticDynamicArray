require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @capacity = 8
    @length = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length == 0
    last_item = @store[@length-1]
    @store[@length-1] = nil
    @length -= 1
    last_item

  end

  # O(1) ammortized on average (it means for each push operation, it takes O(1) time)
  def push(val)
    resize! if @length >= capacity
    @store[@length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" if @length == 0
    target = @store[0]
    i=0
    while(i<@length-1)
      @store[i] = @store[i+1]
      i+=1
    end
    @length -=1
    target
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if @length >= capacity
    i=@length
    while(i>=1)
      @store[i] = @store[i-1]
      i-=1
    end
    @store[0] = val
    @length +=1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" unless index >=0 && index < length
  end

  # O(n): has to copy over all the elements to the new store.
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
end
