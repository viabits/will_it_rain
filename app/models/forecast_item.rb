class ForecastItem
  include Mongoid::Document
  field :hour, type: String
  field :qpf, type: String
  field :temp, type: String
  field :feelslike, type: String
  field :wspd, type: String
  field :humidity, type: String
  field :icon_url, type: String
  field :condition, type: String
  validates :hour, presence: true

  embedded_in :forecast
end
