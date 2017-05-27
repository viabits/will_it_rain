require 'forecast'
class ForecastCreatorJob
  include SuckerPunch::Job

  def perform(forecast_items)
    SuckerPunch.logger.info("Job starting at #{Time.current}")
    Forecast.create_forecast_items(forecast_items)
  rescue StandardError => e
    SuckerPunch.logger.info(e)
  ensure
    SuckerPunch.logger.info("Job finishing at #{Time.current}")
  end

end
