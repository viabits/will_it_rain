require 'rails_helper'
#require_relative '../../../lib/web_services/forecast'
require_relative '../../mocks/web_services/forecast'

RSpec.describe WebServices::Forecast, type: :lib do

  before do
    Mongoid.purge!
  end

  subject do
    WebServices::Forecast.new(station, next_hour).forecast_items
  end

  context 'when invalid parameters' do
    context 'and negative next_hour' do
      let(:station) {:ibirapuera}
      let(:next_hour) {-1}

      it 'returns empty array' do
        expect(subject).to eql({})
      end

    end

    context "and station doesn't exist" do
      let(:station) {:xxx}
      let(:next_hour) {1}

      it 'returns empty array' do
        expect(subject).to eql({})
      end

    end

  end

  context 'when valid parameters' do
    context 'and one station' do
      context 'and next_hour is of string type' do
        let(:station) {:usp}
        let(:next_hour) {'1'}

        it 'returns result correctly' do
          expect(subject).to be_a_kind_of(Hash)
        end

      end

      context 'and station is of string type' do
        let(:station) {'usp'}
        let(:next_hour) {1}

        it 'returns result correctly' do
          expect(subject).to be_a_kind_of(Hash)
        end

      end

      context 'and empty next_hour' do
        let(:station) {:ibirapuera}
        let(:next_hour) {nil}

        it 'returns result correctly' do
          expect(subject).to be_a_kind_of(Hash)
        end

      end

      context 'and next hour' do
        let(:station) {:ibirapuera}
        let(:next_hour) {0}
        let(:station_first) {subject[station].first}

        it 'returns a Hash' do
          expect(subject).to be_a_kind_of(Hash)
        end

        it 'returns a one item Hash' do
          expect(subject.size).to eql(1)
        end

        it 'returns a one sized array correctly' do
          expect(subject[station].size).to eql(1)
        end

        it 'returns hour correctly' do
          expect(station_first[:hour]).not_to be_nil
        end

        it 'returns qpf (Quantitative precipitation forecast (Chance de Chuva)) correctly' do
          expect(station_first[:qpf]).not_to be_nil
        end

        it 'returns temp (temperature) correctly' do
          expect(station_first[:temp]).not_to be_nil
        end

        it 'returns feelslike (sensacao termica) correctly' do
          expect(station_first[:feelslike]).not_to be_nil
        end

        it 'returns wspd (Wind Speed (Velocidade do Vento)) correctly' do
          expect(station_first[:wspd]).not_to be_nil
        end

        it 'returns humidity (Umidade) correctly' do
          expect(station_first[:humidity]).not_to be_nil
        end

        it 'returns icon_url (Endereco do icone) correctly' do
          expect(station_first[:icon_url]).not_to be_nil
        end

        it 'returns condition (Condicoes do clima: nublado, Chance of a Thunderstorm, etc) correctly' do
          expect(station_first[:condition]).not_to be_nil
        end

      end

      context 'and next two hours' do
        let(:station) {:ibirapuera}
        let(:next_hour) {1}

        it 'returns a two sized array correctly' do
          expect(subject[station].size).to eql(2)
        end

      end

      context 'and next three hours' do
        let(:station) {:usp}
        let(:next_hour) {2}

        it 'returns a three sized array correctly' do
          expect(subject[station].size).to eql(3)
        end

      end

    end

    context 'and all stations' do
      context 'and empty parameters' do
        let(:station) {nil}
        let(:next_hour) {nil}

        it 'returns a two sized station hash correctly' do
          expect(subject.size).to eql(2)
        end

        it 'returns first station with a one sized station item array correctly' do
          expect(subject[:ibirapuera].size).to eql(1)
        end

        it 'returns second station with a one sized station item array correctly' do
          expect(subject[:usp].size).to eql(1)
        end

      end

      context 'and next hour' do
        let(:station) {nil}
        let(:next_hour) {0}

        it 'returns a two sized station hash correctly' do
          expect(subject.size).to eql(2)
        end

        it 'returns first station with a one sized station item array correctly' do
          expect(subject[:ibirapuera].size).to eql(1)
        end

        it 'returns second station with a one sized station item array correctly' do
          expect(subject[:usp].size).to eql(1)
        end

      end

      context 'and next two hours' do
        let(:station) {nil}
        let(:next_hour) {1}

        it 'returns a two sized station hash correctly' do
          expect(subject.size).to eql(2)
        end

        it 'returns first station with a two sized station item array correctly' do
          expect(subject[:ibirapuera].size).to eql(2)
        end

        it 'returns second station with a two sized station item array correctly' do
          expect(subject[:usp].size).to eql(2)
        end

      end

      context 'and next three hours' do
        let(:station) {nil}
        let(:next_hour) {2}

        it 'returns a two sized station hash correctly' do
          expect(subject.size).to eql(2)
        end

        it 'returns first station with a three sized station item array correctly' do
          expect(subject[:ibirapuera].size).to eql(3)
        end

        it 'returns second station with a three sized station item array correctly' do
          expect(subject[:usp].size).to eql(3)
        end

      end

    end

  end

end
