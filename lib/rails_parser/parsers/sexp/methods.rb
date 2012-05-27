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
    case self[0]
    when :array
      self[1..-1].map(&:to_value)
    when :call
      self[3..-1].map(&:to_value)
    else
      raise ArgumentError, "expression must be an :array or a :call"
    end
  end
  alias_method :to_a, :to_array
  
  def to_value
    case self[0]
    when :str, :lit
      self[1]
    when :true
      true
    when :false
      false
    when :nil
      nil
    when :array
      self.to_array
    else 
      raise ArgumentError, "Unknown Type: #{self[0]}"
    end
  end
end