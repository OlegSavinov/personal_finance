class Cibc < BankStatementParser
  include BankStatementsHelper

  attr_accessor :file, :pages, :data

  TRANSACTION_REGEX = /(?<date>\w{3} \d{2})\s+\u2192\s+(?<posted_date>\w{3} \d{2})\s+-\s+(?<description>.+?)\s+-\s+\$?(?<amount>[\d,]+\.\d{2})/i

  def initialize(file)
    @file = file
    @data = Hash.new
  end

  def get_basic_info
    @pages ||= extract_pdf_text_pages(file)
    data[:bank_name] = "CIBC"
    title_page = pages.first
    data[:full_name] = title_page[0]
    data[:statement_date] = Date.parse(title_page[5])
    data[:account_number] = title_page[3]
    data[:purchases] = get_purchases title_page
    data.merge! get_statement_period title_page

    data
  end

  def get_transactions
    # TODO
  end

  def get_data
    data
  end

  #private
  def get_purchases(page)
    page.find{|line| line.include?('Purchases')}.split(" ").last.gsub(",", "").to_f
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
