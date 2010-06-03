module DisplaysHelper
  
  # turn consumption and production into colors for orb led
  def to_colors (cons_now, prod_now, cons_yst, prod_yst)
    colors = {}
    
    colors[:red] = case cons_now.to_int
      when 0..4.99 then 256
      when 5..9.99 then 150
      when 10..12.99 then 75
      else 0
    end

    colors[:green] = case prod_now.to_int
      when 0..0.99 then 256
      when 1..3.99 then 200
      when 4..12.99 then 150
      when 13..21.99 then 75
      else 0
    end
    
    colors[:blue] = 256
  end
  
end
