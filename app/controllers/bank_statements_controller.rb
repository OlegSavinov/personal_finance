class BankStatementsController < ApplicationController
  def new
    @bank_statement = BankStatement.new
  end

  def create
    @bank_statement = BankStatement.new(bank_statement_params)
    # @bank_statement.user = current_user  # Assuming you have authentication set up with Devise

    if @bank_statement.save
      # Pass the uploaded file to BankStatementParser for parsing
      parser = BankStatementParser.call(@bank_statement.file)
      parser.parse

      redirect_to bank_statement_path(@bank_statement), notice: "Bank statement processed successfully."
    else
      Rails.logger.info @bank_statement.errors
      render :new, alert: "Failed to upload the bank statement."
    end
  end

  private

  def bank_statement_params
    params.require(:bank_statement).permit(:file)
  end
end
