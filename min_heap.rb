class MinHeap
  attr_reader :elements

  def initialize
    @elements = [nil]
  end

  def <<(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  def pop
    return nil if @elements.size <= 1
    exchange(1, @elements.size - 1)
    max = @elements.pop
    bubble_down(1)
    max
  end

  private

  def bubble_up(i)
    parent_i = (i/2)

    return if i <= 1
    return if @elements[parent_i]["token"] <= @elements[i]["token"]

    exchange(i, parent_i)
    bubble_up(parent_i)
  end

  def bubble_down(i)
    child_index = (i * 2)

    return if child_index > @elements.size - 1

    not_the_last_element = child_index < @elements.size - 1
    left_element = @elements[child_index]
    right_element = @elements[child_index + 1]
    child_index += 1 if not_the_last_element && right_element["token"] < left_element["token"]

    return if @elements[i]["token"] <= @elements[child_index]["token"]

    exchange(i, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]
  end
end