puts 'just loaded the maruku_filter'
class MarukuFilter < Filter
  def self.process(string)
    Maruku.new(string).to_html
  end
end
