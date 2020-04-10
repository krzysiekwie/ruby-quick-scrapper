require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'

def scrapper
	url = "https://bulldogjob.pl/companies/jobs"
	unparsed_page = HTTParty.get(url)
	parsed_page = Nokogiri::HTML(unparsed_page)
	
	listing = Array.new #store all in array
	page = 1
	last_page = 10
	while page <= last_page
		inc_url = "https://bulldogjob.pl/companies/jobs?page=#{page}"
		puts inc_url
		puts "Page: #{page}"

		inc_unparsed_page = HTTParty.get(url)
		inc_parsed_page = Nokogiri::HTML(inc_unparsed_page)

		inc_jobs = inc_parsed_page.css("a.job-item")
		inc_jobs.each do |jobnode|
			job = {
				joburl: jobnode.attributes['href'].value, #href attrib on whole card
				title: jobnode.css("div.job-details div.title h2").text.strip, #3 nested tags
				company: jobnode.css("div.job-details div.meta div.company").text.strip,
				location: jobnode.css("div.job-details div.meta div.location").text.strip,
				salary: jobnode.css("div.job-details div.salary").text.strip
			}
			listing << job
		end
		page += 1
	end
	
	  CSV.open("data.csv", "w", headers: listing.first.keys) do |csv|
	    listing.each do |h|
	      csv << h.values
	    end
	  end

	# byebug

	# CSV.open("data.csv", "wb") {|csv| listing.to_a.each {|elem| csv << elem} }

	# CSV.open('scraped_jobs.csv', 'w') do |csv|
	# 		csv << listing
	# end

end

scrapper