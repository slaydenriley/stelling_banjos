require_relative "../lib/scraper.rb"
require_relative "../lib/banjos.rb"
require 'pry'
require 'colorize'

class Cli

  def start
    puts ""
    puts "    ███████╗████████╗███████╗██╗     ██╗     ██╗███╗   ██╗ ██████╗     ██████╗  █████╗ ███╗   ██╗     ██╗ ██████╗ ███████╗".colorize(:green)
    puts "    ██╔════╝╚══██╔══╝██╔════╝██║     ██║     ██║████╗  ██║██╔════╝     ██╔══██╗██╔══██╗████╗  ██║     ██║██╔═══██╗██╔════╝".colorize(:green)
    puts "    ███████╗   ██║   █████╗  ██║     ██║     ██║██╔██╗ ██║██║  ███╗    ██████╔╝███████║██╔██╗ ██║     ██║██║   ██║███████╗".colorize(:green)
    puts "    ╚════██║   ██║   ██╔══╝  ██║     ██║     ██║██║╚██╗██║██║   ██║    ██╔══██╗██╔══██║██║╚██╗██║██   ██║██║   ██║╚════██║".colorize(:green)
    puts "    ███████║   ██║   ███████╗███████╗███████╗██║██║ ╚████║╚██████╔╝    ██████╔╝██║  ██║██║ ╚████║╚█████╔╝╚██████╔╝███████║".colorize(:green)
    puts "    ╚══════╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚════╝  ╚═════╝ ╚══════╝".colorize(:green)
    puts "    ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████".colorize(:green)
    puts ""
    puts "    Hello! Welcome to the Stelling Banjos catelog! The best banjos in the world!"
    first_menu
  end

  def first_menu
    puts ""
    puts "    -Type 'Enter' to view the catelog.".colorize(:green)
    puts "    -Type 'Exit' to leave.".colorize(:red)
    puts ""
    input = gets.strip.downcase
    case input
    when "enter"
      puts ""
      puts "    Loading...".colorize(:red)
      create_banjos
      display_banjos
    when "exit"
      exit_out
    else
      puts ""
      puts "    Not sure what you mean!".colorize(:red)
      puts ""
      first_menu
    end
  end

  def create_banjos
    Scraper.scrape_catelog_page
    Banjos.create_from_catelog(Scraper.all)
  end

  def display_banjos
    puts ""
    puts "    ██████╗ █████╗ ████████╗███████╗██╗      ██████╗  ██████╗  ".colorize(:green)
    puts "    ██╔════╝██╔══██╗╚══██╔══╝██╔════╝██║     ██╔═══██╗██╔════╝ ".colorize(:green)
    puts "    ██║     ███████║   ██║   █████╗  ██║     ██║   ██║██║  ███╗".colorize(:green)
    puts "    ██║     ██╔══██║   ██║   ██╔══╝  ██║     ██║   ██║██║   ██║".colorize(:green)
    puts "    ╚██████╗██║  ██║   ██║   ███████╗███████╗╚██████╔╝╚██████╔╝".colorize(:green)
    puts "    ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝ ╚═════╝  ╚═════╝  ".colorize(:green)
    puts "    ███████████████████████████████████████████████████████████".colorize(:green)
    puts ""
    Banjos.all.each.with_index do |banjo, index|
      if banjo.sold_out?
        puts "    #{index + 1}. #{banjo.name} - #{banjo.price}" + " - SOLD OUT".colorize(:red)
      else
        puts "    #{index + 1}. #{banjo.name} - #{banjo.price}"
      end
    end

    puts ""
    puts "    Please enter the banjo number for more information, or type 'exit' to leave:"
    input = gets.strip
    if input.downcase == "exit"
      exit_out
    else
      puts ""
      puts "    Loading..."
      puts ""
      info_page_display(input)
    end
  end

  def second_menu
    puts ""
    puts "    Type 'catelog' to view the catelog again:"
    puts "    Type 'exit' to exit"
    input = gets.strip
    if input.downcase == "catelog"
      display_banjos
    elsif input.downcase == "exit"
      exit_out
    else
      puts ""
      puts "    Not sure what you mean! Please make a valid entry...".colorize(:red)
      second_menu
    end
  end

  def info_page_display(input)
    puts "    #{Banjos.all[input.to_i - 1].name} - #{Banjos.all[input.to_i - 1].price}".colorize(:green)
    puts "    ------------------------------"
    puts "    #{Scraper.scrape_info_page(Banjos.all[input.to_i - 1].link)}"
    puts "    ------------------------------"
    puts "    Interested in buying? Go here:"
    puts "    #{Banjos.all[input.to_i - 1].link}".colorize(:blue).underline
    puts "    ------------------------------"
    second_menu
  end

  def exit_out

    puts "    ██████╗  ██████╗  ██████╗ ██████╗ ██████╗ ██╗   ██╗███████╗██╗ ".colorize(:red)
    puts "    ██╔════╝ ██╔═══██╗██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔════╝██║".colorize(:red)
    puts "    ██║  ███╗██║   ██║██║   ██║██║  ██║██████╔╝ ╚████╔╝ █████╗  ██║".colorize(:red)
    puts "    ██║   ██║██║   ██║██║   ██║██║  ██║██╔══██╗  ╚██╔╝  ██╔══╝  ╚═╝".colorize(:red)
    puts "    ╚██████╔╝╚██████╔╝╚██████╔╝██████╔╝██████╔╝   ██║   ███████╗██╗".colorize(:red)
    puts "    ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚══════╝╚═╝ ".colorize(:red)
    puts "    ███████████████████████████████████████████████████████████████".colorize(:red)
    puts ""
  end
end
