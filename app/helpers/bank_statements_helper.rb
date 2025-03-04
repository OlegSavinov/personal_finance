module BankStatementsHelper
  def extract_pdf_text_pages(file)
    pages = []
    @file.blob.open do |file|
       pages = PDF::Reader.new(file).pages.map { |page| 
        page
          .text
          .split("\n")
          .map(&:strip)
          .select { |x| !x.empty? }
      }
    end
    pages
  end
end
