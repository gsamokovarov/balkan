module Support
  module PDFAssertions
    def assert_pdf_content(pdf, *contents)
      text_analysis = PDF::Inspector::Text.analyze pdf
      text_content = text_analysis.strings.map(&:strip).join " "

      contents.each do |content|
        assert_include? text_content, content
      end
    end
  end
end
