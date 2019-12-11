require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  @@all = []

  def self.scrape_catelog_page
    html = "https://www.elderly.com/collections/stelling"
    catelog = Nokogiri::HTML(open(html))
    catelog.css("div.ProductItem").each do |banjo|
      name = banjo.css("h2").text.strip
      if banjo.css("span").text.strip.include?("Sold out")
        sold_out = "Yes"
        price = "$" + banjo.css("span").text.strip.split("$").pop.to_s
      else
        sold_out = "No"
        price = banjo.css("span").text.strip
      end
      link = html + banjo.css("a").map{|link| link['href']}[0]
      @@all << {name: name, price: price, link: link, sold_out: sold_out}
    end
  end

  def self.scrape_info_page(link)
    info = Nokogiri::HTML(open("https://www.elderly.com/collections/stelling/products/stelling-staghorn-with-old-wood-rim-case-2"))
    binding.pry
  end

  def self.all
    @@all
  end

end
