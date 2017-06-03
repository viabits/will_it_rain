module WebServices
  class Forecast
    def initialize(station = nil, next_hours)
      @stations = Settings.wunderground.stations
      @station = station.nil? ? station : station.to_sym
      @next_hours = next_hours.to_i
    end

    def forecast_items
      return {} unless valid_parameters?
      hash_stations = {}
      selected_stations.each {|station| hash_stations[to_name(station)] = station_items_to_array(station)}
      return hash_stations
    end

    private

    def station_items_to_array station
      array_station_items = []
      station_items(station).each do |station_item|
        array_station_items << to_hash(station_item)
      end
      array_station_items
    end

    def to_name station
      station[0]
    end

    def to_hash station_item
      hour = station_item['FCTTIME']['hour']
      qpf = station_item["qpf"]["metric"]
      temp = station_item["temp"]["metric"]
      feelslike = station_item["feelslike"]["metric"]
      wspd = station_item["wspd"]["metric"]
      humidity = station_item["humidity"]
      icon_url = station_item["icon_url"]
      condition = station_item["condition"]
      {hour: hour, qpf: "#{qpf}%", temp: temp, feelslike: feelslike,
       wspd: wspd, humidity: "#{humidity}%", icon_url: icon_url,
       condition: condition}
    end

    def station_items station
      pws = pws_station(station)
      api = WUNDERGROUND_API.hourly_for(pws)
      api["hourly_forecast"].take(@next_hours+1)
    end

    def pws_station station
      station[1][:pws]
    end

    def forecast_api_items station
      @forecast_api_items ||=
        begin
          api = WUNDERGROUND_API.hourly_for(station[1][:pws])
          api["hourly_forecast"][@next_hours-1]
        end
    end

    def selected_stations
      return @stations if @station.nil?
      @stations.to_hash.select{|k, v| k == @station}
    end

    def valid_parameters?
      return false if @next_hours.nil? || @next_hours < 0
      return true if @station.nil?
      return false unless @stations.to_hash.has_key?(@station)
      true
    end

  end

end
