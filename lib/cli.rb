require_relative "../lib/scraper.rb"
require_relative "../lib/banjos.rb"
require 'pry'
require 'colorize'

class Cli

  def run
    start
    create_banjos
    display_banjos
    more_info
  end

  def start
    Scraper.scrape_catelog_page
    puts "Hello, welcome to the banjo deals catelog!"
    puts "Type 'Enter' to view the catelog. Type 'Exit' to leave."

    if gets.strip.downcase == "enter"
      display_banjos
    elsif gets.strip.downcase == "exit"
      self.exit
    else
      puts "Not sure what you mean!"
    end
  end

  def create_banjos
    Banjos.create_from_catelog(Scraper.all)
  end

  def display_banjos
    Banjos.all.each.with_index do |banjo, index|
      if banjo.sold_out?
        puts "#{index + 1}. #{banjo.name} - #{banjo.price}" + " - SOLD OUT".colorize(:red)
      else
        puts "#{index + 1}. #{banjo.name} - #{banjo.price}"
      end
    end
  end

  def more_info
  end
end
