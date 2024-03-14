class BillingCycle < ApplicationRecord
  has_many :payments
  has_many :transactions

  scope :current, -> { where(active: true) }
end
