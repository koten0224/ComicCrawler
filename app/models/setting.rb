class Setting < ApplicationRecord
  belongs_to :item, polymorphic: true
end
