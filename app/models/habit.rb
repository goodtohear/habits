class Habit < NSObject
  attr_accessor :title
  def initialize(options={})
    @title = "New habit"
  end
  
  def self.all
    @all ||= (0..2).map do |item|
      Habit.new
    end
  end
  
end