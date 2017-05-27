require 'rails_helper'

RSpec.describe Forecast, type: :model do

  before do
    Mongoid.purge!
  end

  let(:ibirapuera) {'ibirapuera'}
  let(:usp) {'usp'}

  let(:param1) {{station: ibirapuera, created_at: Time.current}}
  let(:param2) {{station: usp, created_at: Time.current}}
  let(:param3) {{station: nil, created_at: nil}}

  describe '.create_forecast_items' do
    let(:item1) {{:hour=>10, :qpf=>"60%", :temp=>17, :feelslike=>16,
                 :wspd=>7, :humidity=>"70%",
                 :icon_url=>"http://icons.wxug.com/i/c/k/nt_chancetstorms.gif",
                 :condition=>"Cloudy"}}
    let(:item2) {{:hour=>11, :qpf=>"80%", :temp=>18, :feelslike=>17,
                 :wspd=>9, :humidity=>"80%",
                 :icon_url=>"http://icons.wxug.com/i/c/k/nt_chancetstorms.gif",
                 :condition=>"Cloudy"}}
    let(:item3) {{:hour=>12, :qpf=>"85%", :temp=>18, :feelslike=>17,
                 :wspd=>8, :humidity=>"87%",
                 :icon_url=>"http://icons.wxug.com/i/c/k/nt_chancetstorms.gif",
                 :condition=>"Cloudy"}}
    let(:forecast_items) {{:usp=> [item1, item2, item3], :ibirapuera=> [item1, item2]}}

    before do
      Forecast.create_forecast_items(forecast_items)
    end

    context "when creating many wheater forescasts" do
      before do
        Forecast.create_forecast_items(forecast_items)
      end

      it "keeps only one station by forecast" do
        expect(Forecast.count).to eql(forecast_items.size)
      end

    end

    context 'creates a valid forecast with' do
      it 'two stations' do
        expect(Forecast.count).to eql(forecast_items.size)
      end

      it 'and first station with three items' do
        expect(Forecast.first.forecast_items.count).to eql(3)
      end

      it 'and second station with two items' do
        expect(Forecast.last.forecast_items.count).to eql(2)
      end

    end

    context "creates an item's station with" do
      subject {Forecast.where(station: :ibirapuera).first.forecast_items.first}

      it 'hour correctly' do
        expect(subject[:hour]).to eql('10')
      end

      it 'qpf correctly' do
        expect(subject[:qpf]).to eql('60%')
      end

      it 'temp correctly' do
        expect(subject[:temp]).to eql('17')
      end

      it 'feelslike correctly' do
        expect(subject[:feelslike]).to eql('16')
      end

      it 'wspd correctly' do
        expect(subject[:wspd]).to eql('7')
      end

      it 'humidity correctly' do
        expect(subject[:humidity]).to eql('70%')
      end

      it 'icon_url correctly' do
        expect(subject[:icon_url]).to eql('http://icons.wxug.com/i/c/k/nt_chancetstorms.gif')
      end

      it 'condition correctly' do
        expect(subject[:condition]).to eql('Cloudy')
      end

    end

  end

  context 'when creating a forecast' do

    context 'and station is ibirapuera' do
      subject {Forecast.create!(param1)}

      it 'creates a valid forecast' do
        expect(subject).to be_valid
      end

    end

    context 'and station is usp' do
      subject {Forecast.create!(param2)}

      it 'creates a valid forecast' do
        expect(subject).to be_valid
      end

    end

    context 'when creating a station' do
      before do
        Forecast.create!(param1)
      end

      context 'and creating the same station' do

        it 'raises uniqueness error validation (Mongoid::Errors::Validations)' do
          expect{Forecast.create!(param1)}.to raise_error(Mongoid::Errors::Validations)
        end

      end

      context "and station's attributes are not present" do
        let(:forecast) {Forecast.create(param3)}
        let(:error) {forecast.errors.messages}

        it 'raises error validation (Mongoid::Errors::Validations)' do
          expect{Forecast.create!(param3)}.to raise_error(Mongoid::Errors::Validations)
        end

        it 'returns station field error message' do
          expect(error[:station][0]).to eql("can't be blank")
        end

        it 'returns created_at field error message' do
          expect(error[:created_at][0]).to eql("can't be blank")
        end

      end

    end

  end

end
