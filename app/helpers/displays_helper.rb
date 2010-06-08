module DisplaysHelper
  
  # turn consumption and production into colors for orb led
  def to_colors (cons_now, prod_now, cons_yst, prod_yst)
    colors = {}
    colors['blue'] = 256

    #colors['red'] = case cons_now.to_int
    #  when 0..4 then 256
    #  when 5..9 then 150
    #  when 10..12 then 75
    #  else 0
    #end

    #colors['blue'] = case prod_now.to_int
    #  when 0 then 256
    #  when 1..3 then 200
    #  when 4..12 then 150
    #  when 13..21 then 75
    #  else 0
    #end
        
    if cons_now > prod_now
      colors['red'] = 0
      colors['green'] = 256
    else
      colors['red'] = 256
      colors['green'] = 0
    end
    
    return colors    
  end
  
end
