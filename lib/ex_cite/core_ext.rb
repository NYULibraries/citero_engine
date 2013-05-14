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
  def join_and_enclose *args
    seperator = args[0]
    left_end = args[1] ? args[1] : ""
    right_end = args[2] ? args[2] : left_end
    left_end + self.join(seperator) + right_end
  end
end