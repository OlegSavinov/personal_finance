module BankStatementParser
  def self.parse(bank_statement)
    @bank_parser = factory(bank_statement).new(bank_statement.file)
    @bank_parser.parse_basic_info
    @bank_parser.parse_transactions
    @bank_parser.data
  end

  def self.factory(bank_statement)
    BankStatementParser::Banks::Cibc
  end
end
