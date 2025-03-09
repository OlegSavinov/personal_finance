class Cibc < BankStatementParser
  include BankStatementsHelper

  attr_accessor :file, :pages, :data

  TRANSACTION_REGEX = /(\w{3} \d{2})\s+(\w{3} \d{2})?\s+(.+?)\s+(\d{1,3}(?:,\d{3})*\.\d{2})$/

  def initialize(file)
    @file = file
    @data = Hash.new
  end

  def parse_basic_info
    @pages ||= extract_pdf_text_pages(file)
    data[:bank_name] = "CIBC"
    title_page = pages.first
    data[:full_name] = title_page[0]
    data[:statement_date] = Date.parse(title_page[5])
    data[:account_number] = title_page[3]
    data[:purchases] = get_purchases title_page
    data.merge! get_statement_period title_page
    true
  end

  def parse_transactions
    transactions = []
    in_transactions_section = false

    @pages.each do |page|
      page.each do |line|
        # Detect start of transactions section
        if line.include?("Your new charges and credits")
          in_transactions_section = true
          next
        end

        # Detect end of transactions section
        if line.start_with?("Page ")
          in_transactions_section = false
        end

        next unless in_transactions_section

        # Match transaction lines (date, posted date, description, amount)
        if line.match(TRANSACTION_REGEX)
          date, posted_date, description, amount = line.match(TRANSACTION_REGEX).captures
          description, bank_category = parse_description(description)
          transactions << {
            date: date,
            posted_date: posted_date || date,
            description: description,
            bank_category: bank_category,
            amount: amount.gsub(",", "").to_f
          }
        end
      end
    end

    data[:transactions] = transactions
    
    if data[:transactions].pluck(:amount).sum == data[:purchases]
      true
    else
      data[:failed_parsing_transactions] = transactions
      data[:transactions] = nil
      false
    end
  end

  def get_data
    data
  end

  #private
  def get_purchases(page)
    page.find{|line| line.include?('Purchases')}.split(" ").last.gsub(",", "").to_f
  end

  def parse_description(line)
    regex = /(?<description>.+?)\s{2,}(?:[A-Z ]+\s{2,})?(?<bank_category>[A-Za-z ,&]+)$/
  
    match = line.match(regex)
    if match
      [match[:description].strip, match[:bank_category].strip]
    else
      [line, nil]
    end
  end

  def get_statement_period(page)
    line = page[7]
    period_start, period_end, year = line.split("to").map{|x| x.split(',')}.flatten.map(&:strip)
    year = " #{year} "

    {
      period_start: Date.parse(period_start+year),
      period_end: Date.parse(period_end+year)
    }
  end
end
