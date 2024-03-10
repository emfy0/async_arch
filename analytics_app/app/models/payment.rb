class Payment < ApplicationRecord
  belongs_to :billing_cycle
  belongs_to :transaction
  belongs_to :user
end
