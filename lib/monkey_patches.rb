class Object
  # Tentatively calls the method, returning nil if it doesn't exist.
  # E.g. "obj.try(:foo).try(:bar).tar(:zoop)" or "obj.try(:foo, :bar, :zoop)"
  def try(*methods)
    methods.inject(self) do |obj, method|
      obj.respond_to?(method) ? obj.send(method) : nil
    end
  end

  # Returns true for '', nil, [] and {}
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

module Enumerable
  # Recursively converts any empty strings to nil
  def nilify!
    blank = ''
    each do |key,val|
      if val.respond_to?(:each)
        val.nilify!
      elsif val == ''
        self[key] = nil
      end
    end
  end
end

class Hash
  # Return a new Hash wil all keys symbolized
  def symbolize_keys
    self.inject({}) do |options, (key, value)|
      options[(key.respond_to?(:to_sym) ? key.to_sym : key)] = value.is_a?(Hash) ? value.symbolize_keys : value
      options
    end
  end
end
