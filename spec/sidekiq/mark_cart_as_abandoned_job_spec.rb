# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe "#perform" do
    let!(:recent_cart) { create(:cart, last_interaction_at: 2.hours.ago) }
    let!(:old_cart) { create(:cart, last_interaction_at: 4.hours.ago) }
    let!(:abandoned_cart) { create(:cart, :old_abandoned) }

    it "mark old carts as abandoned" do
      expect(old_cart.status).to eq("active")

      MarkCartAsAbandonedJob.new.perform

      old_cart.reload
      expect(old_cart.status).to eq("abandoned")
    end

    it "does not change recent carts" do
      expect(recent_cart.status).to eq("active")

      MarkCartAsAbandonedJob.new.perform

      recent_cart.reload
      expect(recent_cart.status).to eq("active")
    end

    it "remove carts abandoned for more than 7 days" do
      expect(Cart.exists?(abandoned_cart.id)).to be_truthy

      MarkCartAsAbandonedJob.new.perform

      expect(Cart.exists?(abandoned_cart.id)).to be_falsey
    end
  end
end
