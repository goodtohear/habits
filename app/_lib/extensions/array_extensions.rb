class Array
  def item_after(item)
    index = index(item)
    return nil unless index and index < count - 1
    return self[index + 1]
  end
  def item_before(item)
    index = index(item)
    return nil unless index and index > 0
    return self[index - 1]
  end
  
end