class MarkCartAsAbandonedJob
  include Sidekiq::Job
  queue_as :default

  def perform(*args)
    # Marca carrinhos como abandonados se não tiverem interação há mais de 3 horas
    Cart.where(status: :active)
        .where("last_interaction_at <= ?", Cart::CONSIDERED_ABANDONED_TIMESPAN.ago)
        .find_each(&:mark_as_abandoned)

    # Remove carrinhos abandonados há mais de 7 dias
    Cart.where(status: :abandoned)
        .where("last_interaction_at <= ?", Cart::REMOVE_ABANDONED_CART_TIMESPAN.ago)
        .find_each(&:destroy)
  end
end
