class Cart < ApplicationRecord
  include PriceCalculable
  
  after_create :schedule_abandonment_check

  CONSIDERED_ABANDONED_TIMESPAN = 3.hours
  REMOVE_ABANDONED_CART_TIMESPAN = 7.days

  has_many :cart_items, dependent: :destroy

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  enum status: { active: 10, abandoned: 20 }

  def total_price
    cart_items.sum(&:total_price)
  end

  def should_be_abandoned?
    last_interaction_at <= CONSIDERED_ABANDONED_TIMESPAN.ago
  end

  def should_be_removed?
    last_interaction_at <= REMOVE_ABANDONED_CART_TIMESPAN.ago
  end

  def mark_as_abandoned
    return unless should_be_abandoned?

    update(status: :abandoned)
  end

  def remove_if_abandoned
    return unless should_be_removed?

    cart_items.destroy_all 
    destroy!
  end

  private

  def schedule_abandonment_check
    return if should_be_abandoned? # Evita agendar se já deveria estar abandonado

    MarkCartAsAbandonedJob.perform_in(CONSIDERED_ABANDONED_TIMESPAN, id)
  end
end
