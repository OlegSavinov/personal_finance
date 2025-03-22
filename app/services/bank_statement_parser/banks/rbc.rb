module BankStatementParser
  module Banks
    class Rbc < BankStatementParser::Base
      def print_bank()
        puts "RBC"
      end
    end
  end
end
