module ExCite
  ActiveSupport.on_load(:after_initialize) do
    ActiveRecord::Base.class_eval do
      include ResourceKey
    end
  end
end