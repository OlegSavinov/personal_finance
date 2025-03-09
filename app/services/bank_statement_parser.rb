class BankStatementParser

  attr_accessor :file

  def self.parse(file)
    bank_parser = determine_bank_parser file
    bank_parser = bank_parser.new(file)

    bank_parser.parse_basic_info
    bank_parser.parse_transactions
    bank_parser.data
  end


  def self.determine_bank_parser(file)
    Cibc
  end

  def file_extension
    File.extname(@file.blob.filename.to_s)
  end

  def parse_basic_info
    raise NotImplementedError
  end

  def parse_transactions
    raise NotImplementedError
  end
end
