
module Coral
module Template
class Aliases < Environment
  #-----------------------------------------------------------------------------
  # Renderers  
   
  def render(input)
    set(:export, true)
    set(:export_text, 'alias ')
    set(:quote, true) 
    return super(input)
  end
end
end
end