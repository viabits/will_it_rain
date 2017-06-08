module WebServices
  class Forecast

    FAKE_FIELDS1 = {hour: 10, qpf: '90%', pop: '90%', temp: 14, feelslike: 13,
                    wspd: 9, humidity: "80%",
                    icon_url: 'http://icons.wxug.com/i/c/k/nt_chancetstorms.gif',
                    condition: 'Cloudy'}

    def initialize(station, next_hour)
      @station = station
      @next_hour = next_hour
    end

    def forecast_items
      return {} if @station == :ibirapuera && @next_hour == -1
      return {} if @station == :xxx && @next_hour == 1
      return {usp: 1} if @station == :usp && @next_hour == '1'
      return {usp: 1} if @station == 'usp' && @next_hour == 1
      return {ibirapuera: 0} if @station == :ibirapuera && @next_hour.nil?
      if @station == :ibirapuera && @next_hour == 0
        result = {ibirapuera: [FAKE_FIELDS1]}
      end
      if @station == :ibirapuera && @next_hour == 1
        result = {ibirapuera: [FAKE_FIELDS1, FAKE_FIELDS1]}
      end
      if @station == :usp && @next_hour == 2
        result = {usp: [FAKE_FIELDS1, FAKE_FIELDS1, FAKE_FIELDS1]}
      end
      if @station.nil?
        result = case @next_hour
                 when nil then
                   {usp: [FAKE_FIELDS1], ibirapuera: [FAKE_FIELDS1]}
                 when 0 then
                   {usp: [FAKE_FIELDS1], ibirapuera: [FAKE_FIELDS1]}
                 when 1 then
                   {usp: [FAKE_FIELDS1, FAKE_FIELDS1],
                    ibirapuera: [FAKE_FIELDS1, FAKE_FIELDS1]}
                 when 2 then
                   {usp: [FAKE_FIELDS1, FAKE_FIELDS1, FAKE_FIELDS1],
                    ibirapuera: [FAKE_FIELDS1, FAKE_FIELDS1, FAKE_FIELDS1]}
                 end
      end
      return result
    end

  end

end
