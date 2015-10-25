# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new

# Read in a page
base_url = "http://www.parliament.nsw.gov.au/prod/parlment/nswbills.nsf/V3BillsListAll?open&vwCurr=V3AllByTitle&vwCat="
page_letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
#page_letters = ["A"]

page_letters.each do |letter|
	page = agent.get(base_url + letter)
	rows = page.at("table").search("tr")

	rows[1..-1].each do |row|
		bill_name = row.search("td")[0].text
		bill_house = row.search("td")[1].text
		bill_url = row.search("td")[0].search("a").attr("href").text

		record = {
	  		bill_name: bill_name,
	  		bill_house: bill_house,
	  		bill_url: bill_url
		}

		p bill_name 

		ScraperWiki.save_sqlite([:bill_name], record)

	end
end


# # Find somehing on the page using css selectors
# p page.at('div.content')
#
# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
