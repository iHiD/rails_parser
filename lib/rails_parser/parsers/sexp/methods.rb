class Sexp
  def to_hash
    raise ArgumentError, "expression must be a :hash" unless self[0] == :hash
   
    hash = {}
    (1..self.length - 1).step(2) do |x|
      hash[self[x][1]] = self[x + 1][1]
    end
    hash
  end
  alias_method :to_h, :to_hash
  
  def to_array
    raise ArgumentError, "expression must be a :arglist or an :array" unless [:arglist, :array].include?(self[0])
    self[1..-1].map(&:to_value)
  end
  alias_method :to_a, :to_array
  
  def to_value
    case self[0]
    when :str, :lit
      return self[1]
    when :true
      return true
    when :false
      return false
    when :nil
      return nil
    else 
      raise ArgumentError, "Unknown Type: #{self[0]}"
    end
  end
end