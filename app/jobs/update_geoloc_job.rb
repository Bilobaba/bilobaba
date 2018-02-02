require 'rest-client'

class UpdateGeolocJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Event.all.each do |e|
      unless e.lat
        response = RestClient.get 'https://maps.googleapis.com/maps/api/geocode/json?address=' + URI.escape(e.address + ', ' + e.zip) + '&key=AIzaSyDLe_PyvRj7Yu7_1kFnj4Xt-iwrvIirn-w'
        unless JSON.parse(response.body)['results'].size == 0
          e.lat = JSON.parse(response.body)['results'][0]['geometry']['location']['lat']
          e.lng = JSON.parse(response.body)['results'][0]['geometry']['location']['lng']
          e.save(validate: false)
        end
      end
    end
  end
end
