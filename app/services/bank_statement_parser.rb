class BankStatementParser

  attr_accessor :file

  def initialize(file)
    @file = file
  end

  def parse
    bank_parser = determine_bank_parser
    bank_parser.parse
  end

  private

  def determine_bank_parser
    # Logic to identify the bank based on the file content
    case file_extension
    when ".pdf"
      puts "Calling CIBC"
      # Identify PDF type banks (example: CIBC, TD, etc.)
      Cibc.new
    when ".csv"
      # Identify CSV type banks (example: RBC, BMO, etc.)
      RBCStatementParser.new(file)
    else
      raise "Unsupported file format"
    end
  end

  def file_extension
    File.extname(@file.blob.filename.to_s)
  end
end
