String.class_eval do
  def formatize
    self.split('_').last.strip
  end
end