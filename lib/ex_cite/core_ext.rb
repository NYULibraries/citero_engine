String.class_eval do
  def formatize
    self.split('_',2).last.strip
  end
  
  def collect &block
    self.split('',1).collect &block
  end
  
  def to_a
    self.split('',1)
  end
end

Array.class_eval do
  def join_and_enclose seperator, *args
    left_end = (args[0] or "")
    right_end = (args[1] or left_end)
    left_end + self.join(seperator) + right_end
  end
end