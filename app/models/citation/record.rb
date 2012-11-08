module Citation
  class Record < ActiveRecord::Base
    attr_accessible :formatting, :raw, :title
  end
  def to_param  # overridden
      "#{title}"
  end
end
