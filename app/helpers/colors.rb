# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class Colors
  COBALT = '#8A95A1'.to_color
  DARK = '#3a4450'.to_color
  GREY = '#b3b3b3'.to_color
  RED = '#C1272D'.to_color

  INFO_YELLOW = "#fbae17".to_color
  
  HEX = {
    green: '#77A247',
    purple: '#875495',
    orange: '#E2804F',
    yellow: '#E7BE2B',
    pink: '#d28895',
    blue: '#488fb4',
    brown: '#7a5d35'
  }

  GREEN = HEX[:green].to_color

  PURPLE = HEX[:purple].to_color
  ORANGE = HEX[:orange].to_color
  YELLOW = HEX[:yellow].to_color
  PINK = HEX[:pink].to_color
  BLUE = HEX[:blue].to_color
  BROWN = HEX[:brown].to_color

  TASK_COLORS = HEX.values.map(&:to_color)
end
