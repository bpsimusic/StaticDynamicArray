require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    #@store is the static Array.
    @store = StaticArray.new(8)
    @capacity = 8
    @length = 0
    #start_idx refers to the start_idx of the static Array.
    @start_idx = 0
  end

  # O(1), get uses the start_idx
  def [](index)
    check_index(index)
    @store[(start_idx + index) % capacity]
  end

  # O(1), set uses the start_idx
  def []=(index, val)
    check_index(index)
    @store[(start_idx + index) % capacity] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length==0
    target = self[@length-1]
    self[@length-1] = nil
    @length-=1
    target
  end

  # O(1) ammortized
  def push(val)
    resize! if @length >= capacity
    @length+=1
    self[@length-1]=val
    nil
  end

  # O(1), push first element out.
  def shift
    raise "index out of bounds" if @length==0
    target = self[0]
    self[0] = nil
    @start_idx = (@start_idx + 1) % @capacity
    #this operation shifts the start_idx to the right one space.
    @length -=1
    target
  end

  # O(1) ammortized, push an element at first space.
  def unshift(val)
    resize! if @length >= @capacity
    @start_idx = (@start_idx - 1) % @capacity
    #this operation puts the starting position at the
    #end of the new resized array, or to the left one space.
    @length+=1
    self[0] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  #make sure you're using a valid index for the static array.
  def check_index(index)
    raise "index out of bounds" unless index >=0 && index < @length
  end

  def resize!
    new_store = StaticArray.new(@capacity * 2)
    @length.times do |i|
      new_store[i] = self[i]
    end
    @capacity *=2
    @store = new_store
    @start_idx = 0
  end
end
