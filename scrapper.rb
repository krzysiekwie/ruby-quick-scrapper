require 'nokogiri'
require 'httparty'
require 'byebug'

def scrapper
	url = "https://bulldogjob.pl/companies/jobs/s/skills,Ruby"
	unparsed_page = HTTParty.get(url)
	parsed_page = Nokogiri::HTML(unparsed_page)
	
	listing = Array.new #store all in array

	jobs = parsed_page.css("a.job-item")
	jobs.each do |jobnode|
		job = {
			joburl: jobnode.attributes['href'].value, #href attrib on whole card
			title: jobnode.css("div.job-details div.title h2").text.strip, #3 nested tags
			company: jobnode.css("div.job-details div.company").text.strip,
			location: jobnode.css("div.job-details div.location").text.strip,
			salary: jobnode.css("div.job-details div.salary").text.strip
		}
		listing << job
	end
end

scrapper