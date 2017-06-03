require_relative '../web_services/forecast'
namespace :forecast do
  # Examples:
  # rake forecast:start
  # ---
  # to run in production environment:
  #   heroku run bash
  #   rake forecast:start
  # ---
  #
  desc 'creating weather forecast from now to 12 hours ahead'
  task :start => [:environment] do |task, args|
    puts "\n----- starting..."
    # nil means all stations
    station = nil
    #
    # 0 means 1 hour ahead
    # 1 means 2 hours ahead
    # 2 means 3 hours ahead and so on.
    next_hour = 11
    #
    puts "\n----- getting Weather Forecasts from API."
    forecast_items = WebServices::Forecast.new(station, next_hour).forecast_items
    #ForecastCreatorJob.perform_async(forecast_items)
    Forecast.create_forecast_items(forecast_items)
    puts "\n----- done."
  end

end
