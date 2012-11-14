module Citation
  class Record < ActiveRecord::Base
    attr_accessible :formatting, :raw, :title
    validates :formatting, :presence => true
    validates :raw, :presence => true
    validates :title, :presence => true
  end
  def to_param  # overridden
      "#{title}"
  end
end
