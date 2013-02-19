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