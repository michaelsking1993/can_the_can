class BaseWord < ApplicationRecord
  belongs_to :pos, optional: true
  belongs_to :language, optional: true
  has_many :inflections, dependent: :destroy
end
