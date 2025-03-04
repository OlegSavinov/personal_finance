class BankStatementParser

  attr_accessor :file

  def self.parse(file)
    bank_parser = determine_bank_parser file
    bank_parser = bank_parser.new(file)

    bank_parser.get_basic_info
    bank_parser.get_transactions
    result
  end


  def self.determine_bank_parser(file)
    Cibc
  end

  def file_extension
    File.extname(@file.blob.filename.to_s)
  end

  def get_basic_info
    raise NotImplementedError
  end

  def get_transactions
    raise NotImplementedError
  end
end
