# Generates a salted token that should be valid for 24 hours
class AuthToken
  RAND_SEEDS = [(0..9), ('a'..'z'), ('A'..'Z')].map(&:to_a).flatten

  attr_reader :salt

  def initialize(salt=nil)
    @salt = salt || self.class.rand_str(rand(32) + 8)
    @date = Date.today
  end

  # Returns the string value of the token
  def to_s
    "#{@salt}_#{@date - 1}_#{@date}"
  end

  # Validates another token against this one
  def ===(other_token)
    not (Regexp.new("^#{@salt}_.*#{@date}") =~ other_token.to_s).nil?
  end

  # Returns a random string of alphanumeric of at most "max" charachters
  def self.rand_str(max=8)
    (0..max-1).map { RAND_SEEDS[rand(RAND_SEEDS.length)] }.join
  end
end
