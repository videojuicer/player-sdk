class Hash

  # Returns a new hash just like this one, but with all the string keys expressed as symbols.
  # Also applies to hashes within self.
  # Based on an implementation within Rails 2.x, thanks Rails!
  def deep_symbolize
    target = dup    
    target.inject({}) do |memo, (key, value)|
      value = value.deep_symbolize if value.is_a?(Hash)
      memo[(key.to_sym rescue key) || key] = value
      memo
    end
  end
  
  # Subtracts one hash from another by removing keys from the actor and recursing on any hash values.
  # Returns a new Hash without affecting the actors.
  # Example 1:
  # {:foo=>"bar"} - {:foo=>"bar"} == {}
  # Example 2 of deep nesting:
  # {:foo=>{:bar=>"baz", :car=>"naz"}, :bar=>"baz"} - {:foo=>{:car=>"naz"}} == {:foo=>{:bar=>"baz"}, :bar=>"baz"}
  def -(arg)
    target = dup; actor = arg.dup
    actor.each do |key, value|
      if value.is_a?(Hash)
        target[key] = target[key] - value
      else
        target.delete(key)
      end
    end
    return target
  end
  
  # Returns a new hash just like this one, but with all STRING keys and values evaluated
  # and rendered as liquid templates using the provided payload hash.
  def deep_liquify(payload={})
    target = dup
    target.inject({}) do |memo, (key, value)|
      value = value.deep_liquify(payload) if value.is_a?(Hash)
      value = value.liquify(payload) if value.is_a?(String)
      key = key.liquify(payload) if key.is_a?(String)
      memo[(key.to_sym rescue key) || key] = value
      memo
    end
  end
    
  # Merges self with another hash, recursively.
  # 
  # This code was lovingly stolen from some random gem:
  # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
  # 
  # Thanks to whoever made it.
  def deep_merge(hash)
    target = dup    
    hash.keys.each do |key|
      if hash[key].is_a? Hash and self[key].is_a? Hash
        target[key] = target[key].deep_merge(hash[key])
        next
      end      
      target[key] = hash[key]
    end    
    target
  end
end