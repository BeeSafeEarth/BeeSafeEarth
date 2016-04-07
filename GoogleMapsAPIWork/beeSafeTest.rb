require 'open-uri'
require 'json'
require 'csv'

#This is a Google Maps API conversion script.

#rawAddress = "1450 Judson Dr."

#Initial Setup
rowsAdded = 0
rowsToAdd = 10
apiKey = "AIzaSyCWAOJAfx45AMBnYGpeeboch2xd99YUdJ8"
regionBounds = "39.937087, -105.693524|40.262729, -105.050824"
f = File.open('apiResponse.txt', 'w')
csv_out = CSV.open('PledgeOutput.csv', 'wb')

addressSheet = CSV.foreach('BeeSafePledgeResponse.csv', :headers => true) do |row|
	#if rowsCleared < rowsToClear

#Pull in addresses from CSV...can add other inputs later
		rawAddress = row["Street Address and Zip Code (No P.O. Boxes, please)"]
		uriAddress = URI::encode(rawAddress)

#Make API Calls to GMaps Geocoder

		response = open("https://maps.googleapis.com/maps/api/geocode/json?address=#{uriAddress}&bounds=#{regionBounds}&key=#{apiKey}").read
		jsonResponse = JSON.parse(response)

		formattedAddress = jsonResponse["results"][0]["formatted_address"]

#Push Address Responses back to CSV

		f.puts(formattedAddress)
		row["Normalized Street Address"] = formattedAddress
		csv_out << row

		#rowsAdded += 1
	#end
end

csv_out.close
f.close

