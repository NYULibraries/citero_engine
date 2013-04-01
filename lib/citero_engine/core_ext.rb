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
  
  def outputize output
    if self.include? "@output" 
      self.gsub!("@output", output)
    end
    self
  end
end

Hash.class_eval do
  def outputize output
    self.values.each {|val| val.outputize output}
  end
end

Array.class_eval do
  def outputize output
    self.each {|val| val.outputize output}
  end
end