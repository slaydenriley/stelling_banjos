require 'pry'
class StellingBanjos::Cli

  LINK = "https://www.elderly.com/collections/stelling"

  def start
    puts ""
    puts "    ██████╗  █████╗ ███╗   ██╗     ██╗ ██████╗ ███████╗██╗".colorize(:green)
    puts "    ██╔══██╗██╔══██╗████╗  ██║     ██║██╔═══██╗██╔════╝██║".colorize(:green)
    puts "    ██████╔╝███████║██╔██╗ ██║     ██║██║   ██║███████╗██║".colorize(:green)
    puts "    ██╔══██╗██╔══██║██║╚██╗██║██   ██║██║   ██║╚════██║╚═╝".colorize(:green)
    puts "    ██████╔╝██║  ██║██║ ╚████║╚█████╔╝╚██████╔╝███████║██╗".colorize(:green)
    puts "    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚════╝  ╚═════╝ ╚══════╝╚═╝".colorize(:green)
    puts "    ██████████████████████████████████████████████████████".colorize(:green)
    puts ""
    puts "    Hello! Welcome to the Stelling Banjos catalog! The best banjos in the world!"
    first_menu
  end

  def first_menu
    puts ""
    puts "    MENU"
    puts "    ══════════════════════════════════"
    puts "    -Press 'Enter' to view the catalog".colorize(:green)
    puts "    -Type 'Exit' to leave".colorize(:red)
    puts "    ══════════════════════════════════"

    input = gets.strip.downcase
    case input
    when ""
      puts "    Loading...".colorize(:red)
      create_banjos
      display_banjos
    when "exit"
      exit_out
    else
      puts "    Please make a valid entry".colorize(:red)
      puts ""
      first_menu
    end
  end

  def create_banjos
    StellingBanjos::Scraper.scrape_catalog_page(LINK)
    StellingBanjos::Banjos.create_from_catalog(StellingBanjos::Scraper.all)
  end

  def display_banjos
    puts ""
    puts "    ██████╗ █████╗ ████████╗ █████╗ ██╗      ██████╗  ██████╗  ".colorize(:green)
    puts "    ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██║     ██╔═══██╗██╔════╝ ".colorize(:green)
    puts "    ██║     ███████║   ██║   ███████║██║     ██║   ██║██║  ███╗".colorize(:green)
    puts "    ██║     ██╔══██║   ██║   ██╔══██║██║     ██║   ██║██║   ██║".colorize(:green)
    puts "    ╚██████╗██║  ██║   ██║   ██║  ██║███████╗╚██████╔╝╚██████╔╝".colorize(:green)
    puts "    ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝  ".colorize(:green)
    puts "    ███████████████████████████████████████████████████████████".colorize(:green)
    puts "                   ~ Supplied by www.elderly.com ~".colorize(:red)
    puts ""

    StellingBanjos::Banjos.all.each.with_index do |banjo, index|
      if banjo.sold_out?
        puts "    #{index + 1}. #{banjo.name} - #{banjo.price}" + " - SOLD OUT".colorize(:red)
      else
        puts "    #{index + 1}. #{banjo.name} - #{banjo.price}"
      end
    end
    second_menu
  end

  def second_menu
    puts ""
    puts "    MENU"
    puts "    ══════════════════════════════════════════"
    puts "    -Enter a banjo number for more information".colorize(:green)
    puts "    -Type 'Exit' to exit".colorize(:red)
    puts "    ══════════════════════════════════════════"

    input = gets.strip
    if input.downcase == "exit"
      exit_out
    elsif input.to_i.between?(1, StellingBanjos::Banjos.all.length)
      puts "    Loading...".colorize(:red)
      info_page_display(input)
    else
      puts ""
      puts "    Please make a valid entry".colorize(:red)
      second_menu
    end
  end

  def info_page_display(input)
    input = input.to_i - 1

    link = StellingBanjos::Banjos.all[input].link
    description = StellingBanjos::Scraper.scrape_info_page(link)
    formatted_description = add_newlines(description, 68)
    name = StellingBanjos::Banjos.all[input].name
    price = StellingBanjos::Banjos.all[input].price

    puts ""
    puts ""
    puts "        █ #{name.upcase} - #{price}".colorize(:green)
    puts ""
    puts "        █ #{formatted_description}"
    puts ""
    if StellingBanjos::Banjos.all[input].sold_out?
      puts "        █ SORRY! This banjo is SOLD OUT from elderly.com! Let's check Google instead...".colorize(:red)
      puts "        ==> https://www.google.com/search?q=#{name.downcase.gsub(" ", "-")}".colorize(:blue)
    else
      puts "        █ Interested in buying? Go here:"
      puts "        ==> #{link}".colorize(:blue)
    end
    puts ""
    third_menu
  end

  def third_menu
    puts ""
    puts "    MENU"
    puts "    ══════════════════════════════════════════"
    puts "    -Enter another banjo number".colorize(:green)
    puts "    -Type 'Catalog' to view the catalog again".colorize(:green)
    puts "    -Type 'Exit' to exit".colorize(:red)
    puts "    ══════════════════════════════════════════"
    puts ""

    input = gets.strip
    if input.downcase == "exit"
      exit_out
    elsif input.to_i.between?(1, StellingBanjos::Banjos.all.length)
      puts "    Loading...".colorize(:red)
      info_page_display(input)
    elsif input.downcase == "catalog"
      display_banjos
    else
      puts ""
      puts "    Please make a valid entry".colorize(:red)
      third_menu
    end
  end

  def add_newlines(string, max_length)
    words = string.split(' ')
    lines = []
    current_line = ''
    until words.empty?
      current_line += " #{words.shift}"
      if current_line.length >= max_length
        lines << current_line
        current_line = ''
      end
    end
    lines.push(current_line).join("\n       ").lstrip
  end

  def exit_out
    puts ""
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
