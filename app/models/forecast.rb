class Forecast
  include Mongoid::Document
  field :station, type: String
  field :created_at, type: Time

  validates :station, uniqueness: {scope: :created_at}
  validates :station, presence: true
  validates :created_at, presence: true

  embeds_many :forecast_items

  def self.create_forecast_items(forecast_items)
    forecast_items.each do |forecast_item|
      destroy_forecast(forecast_item)
      create_forecast(forecast_item)
    end
  end

  private

  def self.destroy_forecast forecast_item
    self.where(station: forecast_item.first).destroy
  end

  def self.create_forecast forecast_item
    forecast = self.create(station: forecast_item.first, created_at: Time.current)
    forecast_item.second.each do |item|
      ForecastItem.create(item_fields(item, forecast))
    end
    forecast.save
  end

  def self.item_fields item, forecast
    { forecast: forecast, hour: item[:hour], qpf: item[:qpf], pop: item[:pop],
      temp: item[:temp],  feelslike: item[:feelslike],
      wspd: item[:wspd], humidity: item[:humidity], icon_url: item[:icon_url],
      condition: item[:condition] }
  end

end
