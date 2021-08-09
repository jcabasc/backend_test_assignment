# frozen_string_literal: true

class CarSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id, :price, :rank_score, :model, :label
  belongs_to :brand

  def rank_score
    @instance_options[:external_cars_recommended][object.id]
  end

  def label
    user = @instance_options[:user]
    preferred_brand_ids = @instance_options[:preferred_brand_ids]

    if object.brand.id.in?(preferred_brand_ids) && object.price.in?(user.preferred_price_range)
      :perfect_match
    elsif object.brand.id.in?(preferred_brand_ids)
      :good_match
    end
  end
end
