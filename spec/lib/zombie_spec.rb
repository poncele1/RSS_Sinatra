require "spec_helper"
require "zombie"

RSpec.describe Zombie do
   it "is named Ash" do 
     zombie = Zombie.new
     expect(zombie.name == 'Ash').to be true
   end

   it "has no brains" do
     zombie = Zombie.new 
     expect(zombie.brains < 1).to be true
   end
   
   it "is hungry" do
      zombie = Zombie.new
      expect(zombie.hungry?).to be true
   end
end
