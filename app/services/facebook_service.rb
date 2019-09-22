class FacebookService
  def self.run_places_graph
    fields = ['id','checkins','engagement','is_verified','link','location','name','overall_star_rating','phone','rating_count','single_line_address','website']
    fields = fields.join(',')
    token = "EAAFfAyix3dUBAHxZBIQdRhrA2oSY2PlhEhYhElW0F8ijAuTLuhdZAeBn2rUD2UD9i1sGdcfVhCmG6sPXCXYn9lRznc8wEOZAHpl4qMKRMiQXF5XZBFaeNZCxD3G3L8fSt5CeB0gW7DR9elIJZA3wC28Ccmw5ZBhZBk2eKnAUVaCcGAw0UKgVsYeFBAKrGW7ZABC7gWetEFzyZArwZDZD"

    neighborhood_list = Address.distinct.pluck(:neighborhood)
    neighborhood_list.reverse.each do |item|
      establishments = Establishment.joins(:addresses).where(addresses: { neighborhood: item }, facebook_updated_at: nil).where.not(addresses: { latitude: nil, longitude: nil })

      next if establishments.blank?
      establishments.each do |establishment|
        lat_lng_str = establishment.addresses.last.latitude.gsub(',','.') + ',' + establishment.addresses.last.longitude.gsub(',','.')
        url = "https://graph.facebook.com/v3.2/search?type=place&center=#{lat_lng_str}&distance=1500&q=pizza&fields=#{fields}&limit=2&access_token=#{token}"
        response = HTTParty.get(url)

        data = response['data']

        break if response['error'].present?
        next if data.blank?

        data.each do |item|
          fb_info = FacebookInfo.create!(facebook_id: item['id'],
                                         checkins: item['checkins'],
                                         engagement: (item['engagement']['count'] rescue nil),
                                         is_verified: item['is_verified'],
                                         facebook_link: item['link'],
                                         name: item['name'],
                                         rating_count: item['rating_count'],
                                         single_line_address: item['single_line_address'],
                                         phone: item['phone'],
                                         overall_star_rating: item['overall_star_rating'],
                                         website: item['website']
                                        )
          establishment.update_attribute(:facebook_updated_at, Time.now)
          location = item['location']
          next if location.blank?

          fb_info.facebook_locations.create!(city: location['city'],
                                             latitude: location['latitude'],
                                             longitude: location['longitude'],
                                             state: location['state'],
                                             street: location['street'],
                                             zip: location['zip']
                                            )
        end
        break if response['error'].blank?
      end
    end
  end
end
