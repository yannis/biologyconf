require 'spec_helper'

describe Category do
  subject {Category.new name: "category_name", fee: 55}

  its(:name){should eq "category_name"}
  its(:fee){should eq 55}
end
