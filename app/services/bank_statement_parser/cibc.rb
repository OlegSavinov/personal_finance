class BankStatementParser::Cibc

  TRANSACTION_REGEX = /(?<date>\w{3} \d{2})\s+\u2192\s+(?<posted_date>\w{3} \d{2})\s+-\s+(?<description>.+?)\s+-\s+\$(?<amount>[\d,]+\.\d{2})/i

  def initialize(file)
    @file = file
  end

  def parse
    puts "Parsing CIBC PDF statement..."
    puts @file
    pdf_text = extract_pdf_text(@file)
    transactions = parse_transactions(pdf_text)
    puts transactions

    transactions.each do |transaction_data|
      #Transaction.create(transaction_data)
    end
  end

  private

  def extract_pdf_text(file)
    #puts "filepath: #{file.path}"
    text = ""
    @file.blob.open do |file|
      reader = PDF::Reader.new(file)
      reader.pages.each do |page|
        text += page.text + "\n"
      end
    end

    text
  end

  def parse_transactions(statement_text)
    transactions = []
    statement_text.scan(TRANSACTION_REGEX) do |date, posted_date, description, amount|
      transactions << {
        date: parse_date(date),
        posted_date: parse_date(posted_date),
        description: description.strip,
        amount: parse_amount(amount),
        category: categorize_transaction(description)
      }
    end
    transactions
  end

  def parse_date(date_string)
    Date.strptime(date_string, '%b %d') rescue nil
  end

  def parse_amount(amount_string)
    amount_string.gsub(',', '').to_f rescue 0.0
  end

  def categorize_transaction(description)
    category_rules = {
      'LYFT' => 'Transportation',
      'UBER' => 'Transportation',
      'SHOPPERS DRUG MART' => 'Health and Education',
      'LOBLAWS' => 'Retail and Grocery',
      'AMAZON' => 'Retail and Grocery',
      'PAYPAL' => 'Retail and Grocery',
      'IMMIGRATION CANADA' => 'Professional and Financial Services',
      'CLASS PASS' => 'Hotel, Entertainment, and Recreation',
      'MCDONALD' => 'Restaurants',
      'SUSHI' => 'Restaurants',
      'DAVIDSTEA' => 'Retail and Grocery'
    }
    category_rules.each do |keyword, category|
      return category if description.upcase.include?(keyword)
    end
    'Uncategorized'
  end
end
