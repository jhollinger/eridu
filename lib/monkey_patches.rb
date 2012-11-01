class Object
  # Returns true for '', nil, [] and {}
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

module Enumerable
  # Recursively converts any empty strings to nil
  def nilify!
    each do |key,val|
      if val.respond_to?(:each)
        val.nilify!
      elsif val == ''
        self[key] = nil
      end
    end
  end
end

# Fix RedCloth's absurdly strict escaping
module RedCloth::Formatters::HTML
  def quote1(opts); "'#{opts[:text]}'"; end
  def quote2(opts); "\"#{opts[:text]}\""; end
  def multi_paragraph_quote(opts); "\"#{opts[:text]}"; end
  def ellipsis(opts); "#{opts[:text]}..."; end
  def emdash(opts); '--'; end
  def endash(opts); ' - '; end
  def squot(opts); "'"; end
end
