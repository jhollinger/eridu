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
