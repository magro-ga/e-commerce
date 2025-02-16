class Cart < ApplicationRecord
  after_create :generate_expire_job

  CONSIDERED_ABANDONED_TIMESPAN = 3.hours
  REMOVE_ABANDONED_CART_TIMESPAN = 7.days

  has_many :cart_items, dependent: :destroy

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  enum status: { active: 10, abandoned: 20 }

  def total_price
    cart_items.sum(&:total_price)
  end

  def mark_as_abandoned
    return unless last_interaction_at <= CONSIDERED_ABANDONED_TIMESPAN.ago

    update(status: :abandoned)
  end

  def remove_if_abandoned
    return unless last_interaction_at <= REMOVE_ABANDONED_CART_TIMESPAN.ago

    destroy!
  end

  private

  def generate_expire_job
    ExpireCartsJob.perform_in(CONSIDERED_ABANDONED_TIMESPAN, self.id)
  end
end
