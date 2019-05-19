class Weather < ActiveRecord::Base
  has_one :location, dependent: :destroy

  def format_weather_data
    {
      id: weather_id,
      date: date,
      temperature: temperature.split(',').map(&:to_f),
      location: {
        lat: location.latitude,
        lon: location.longitude,
        city: location.city,
        state: location.state
      }
    }
  end
end
