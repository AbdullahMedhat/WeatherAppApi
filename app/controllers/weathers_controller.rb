class WeathersController < ApplicationController

  def index
    if params[:date].present?
      @weathers = Weather.includes(:location).where(
        date: params[:date]
      ).order('weathers.weather_id ASC')
      locations_exist = all_locations_exist
      if locations_exist
        render json: { message: 'No records found' }, status: :not_found
        return
      end
    elsif params[:lat].present? && params[:lon].present?
      @weathers = Weather.includes(:location).where(
        'locations.latitude = ? AND locations.latitude = ?',
        params[:lat], params[:lon]
      ).order('weathers.weather_id ASC')
      locations_exist = all_locations_exist
      if locations_exist
        render json: { message: 'No records found' }, status: :not_found
        return
      end
    else
      @weathers = Weather.includes(:location).order('weathers.weather_id ASC')
    end
    render json: @weathers.map(&:format_weather_data), status: :ok
  end

  def erase
    if params[:start].present? && params[:end].present?
      @weathers = Weather.includs(:location).where(
        'weathers.date > ? AND weathers.date < ? AND locations.lat = ? AND locations.lon = ?',
        params[:start], params[:end], params[:lat], params[:lon]
      )
      @weathers.destroy_all
    else
      Weather.destroy_all
    end
    render json: { message: 'Data deleted successfully' }, status: :ok
  end

  def create
    weather_data = weather_params
    id_exist = Weather.find_by(weather_id: params[:id])
    if id_exist.blank?
      new_weather = Weather.new(weather_data)
      new_weather.temperature = params[:temperature].join(',')
      new_weather.weather_id = params[:id]
      new_weather.save
      create_weather_location(new_weather.id)
      render json: { message: 'Weather has been created successfully' },
             status: :created
    else
      render json: { message: 'ID is exist' }, status: :bad_request
    end
  end

  private

  def create_weather_location(weather_id)
    Location.create(
      latitude: params[:location][:lat],
      longitude: params[:location][:lon],
      city: params[:location][:city],
      state: params[:location][:state],
      weather_id: weather_id
    )
  end

  def all_locations_exist
    @weathers.each do |weather|
      return true if  weather.location.blank?
    end
    false
  end

  def weather_params
    params.permit(
      :id, :date, :temperature, :weather_id,
      location_attributes: %i[lat lon city state]
    )
  end
end
