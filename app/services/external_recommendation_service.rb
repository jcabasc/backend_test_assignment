# frozen_string_literal: true

require 'net/http'

class ExternalRecommendationService
  DEFAULT_URL = 'https://bravado-images-production.s3.amazonaws.com/recomended_cars.json'

  def self.call(user_id)
    new(user_id).call
  end

  def initialize(user_id)
    @user_id = user_id
  end

  def call
    response = JSON.parse(Net::HTTP.get(uri))
    response.each_with_object(Hash.new(0)) do |element, hash|
      hash[element['car_id']] = element['rank_score']
    end.sort_by { |k, v| -v }.to_h
  end

  private

  attr :user_id

  def uri
    URI("#{DEFAULT_URL}?user_id=#{user_id}")
  end
end
