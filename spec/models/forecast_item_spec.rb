require 'rails_helper'

RSpec.describe ForecastItem, type: :model do

  before do
    Mongoid.purge!
  end

  let(:ibirapuera) {'ibirapuera'}
  let(:usp) {'usp'}

  let(:param_forecast) {{station: ibirapuera, created_at: Time.current}}
  let(:param_forecast_item) do
    {forecast: forecast, hour: '06', qpf: '60%', pop: '60%',
     temp: '14', feelslike: '13', wspd: '07',
     humidity: '88%', icon_url: 'http://icons.wxug.com/i/c/k/nt_chancetstorms.gif',
     condition: 'Chance of a Thunderstorm'}
  end

  context 'when creating a station item' do
    context "and its parent station doesn't exist" do
      subject {ForecastItem.create!({hour: '06', pop: '60%'})}

      it 'raises noparent error validation (Mongoid::Errors::NoParent)' do
        expect{subject}.to raise_error(Mongoid::Errors::NoParent)
      end

    end

  end

  context 'when creating a forecast item' do
    let(:forecast) {Forecast.create(param_forecast)}
    subject {ForecastItem.create(param_forecast_item)}

    it 'creates forecast item correctly' do
      expect(subject).to be_valid
    end

    it 'creates hour correctly' do
      expect(subject[:hour]).to eql(param_forecast_item[:hour])
    end

     it 'creates qpf correctly' do
      expect(subject[:qpf]).to eql(param_forecast_item[:qpf])
    end

    it 'creates pop correctly' do
      #r = ForecastItem.create(param_forecast_item)
      expect(subject[:pop]).to eql(param_forecast_item[:pop])
    end

    it 'creates temp correctly' do
      expect(subject[:temp]).to eql(param_forecast_item[:temp])
    end

    it 'creates feelslike correctly' do
      expect(subject[:feelslike]).to eql(param_forecast_item[:feelslike])
    end

    it 'creates wspd correctly' do
      expect(subject[:wspd]).to eql(param_forecast_item[:wspd])
    end

    it 'creates humidity correctly' do
      expect(subject[:humidity]).to eql(param_forecast_item[:humidity])
    end

    it 'creates icon_url correctly' do
      expect(subject[:icon_url]).to eql(param_forecast_item[:icon_url])
    end

    it 'creates condition correctly' do
      expect(subject[:condition]).to eql(param_forecast_item[:condition])
    end

  end

end
