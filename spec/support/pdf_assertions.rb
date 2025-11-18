module Support
  module PDFAssertions
    def assert_pdf_content(pdf, *contents)
      analysis = PDF::Inspector::Text.analyze pdf
      text_content = analysis.strings.map(&:strip).join " "

      contents.each { assert_include? text_content, it }
    end

    def assert_without_pdf_content(pdf, *contents)
      analysis = PDF::Inspector::Text.analyze pdf

      analysis.strings.each do |string|
        contents.each { assert_not_eq string, it }
      end
    end
  end
end
