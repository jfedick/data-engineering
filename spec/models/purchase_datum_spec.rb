require 'spec_helper'

describe PurchaseDatum do
  subject(:purchase_datum) { FactoryGirl.build(:purchase_datum) }
  let(:line) { "Snake Plissken\t$10 off $20 of food\t10.0\t2\t987 Fake St\tBob's Pizza\n" }

  describe '#process_file!' do
    it 'should call parse lines on each line in the file' do
      
      file = File.new("#{Rails.root}/example_input.tab")
      purchase_datum.stub_chain(:file, :file, :to_file).and_return(file)
      purchase_datum.stub(:parse!)
      file.lines.each_with_index do |line, index|
        next if index == 0
        purchase_datum.should_receive(:parse!).with(line)
      end
      file.rewind 
      purchase_datum.process_file!
    end
  end

  describe '#parse!' do    
    describe 'as it relates to Purchasers' do
      before :each do
        Purchaser.destroy_all
        Purchaser.all.count.should == 0
        purchase_datum.parse!(line)      
      end

      it 'should create a new purchaser if one from the line does not exist' do
        Purchaser.all.count.should == 1
      end

      it 'should not create a new purchaser if they already exist' do
        purchase_datum.parse!(line)
        Purchaser.all.count.should == 1
      end

      it 'should create a purchaser with the name from the line' do
        Purchaser.first.name.should == line.strip.split(/\t/)[0]
      end
    end

    describe 'as it relates to Items' do
      before :each do
        Item.destroy_all
        Item.all.count.should == 0
        purchase_datum.parse!(line)      
      end
      
      it 'should create a new item if one from the line does not exist' do
        Item.all.count.should == 1
      end

      it 'should not create a new item if it already exists' do
        purchase_datum.parse!(line)
        Item.all.count.should == 1
      end

      it 'should create an item with the description from the line' do
        Item.first.description.should == line.strip.split(/\t/)[1]
      end

      it 'should create an item with the price from the line' do
        Item.first.price.should == line.strip.split(/\t/)[2].to_f
      end
    end

    describe 'as it relates to Merchants' do
      before :each do
        Merchant.destroy_all
        Merchant.all.count.should == 0
        purchase_datum.parse!(line)      
      end
      
      it 'should create a new merchant if one from the line does not exist' do
        Merchant.all.count.should == 1
      end

      it 'should not create a new merchant if it already exists' do
        purchase_datum.parse!(line)
        Merchant.all.count.should == 1
      end

      it 'should create a merchant with the address from the line' do
        Merchant.first.address.should == line.strip.split(/\t/)[4]
      end

      it 'should create a merchant with the name from the line' do
        Merchant.first.name.should == line.strip.split(/\t/)[5]
      end
    end

    describe 'as it relates to Purchases' do
      before :each do
        Purchase.destroy_all
        Purchase.all.count.should == 0
        purchase_datum.parse!(line)      
      end
      
      it 'should create a new purchase' do
        Purchase.all.count.should == 1
      end

      it 'should create a purchase with the purchase_datum' do
        Purchase.first.purchase_datum.id.should == purchase_datum.id
      end

      it 'should create a purchase with the purchaser from the line' do
        Purchase.first.purchaser.name == line.strip.split(/\t/)[0]
      end      

      it 'should create a purchase with the item from the line' do
        Purchase.first.item.description == line.strip.split(/\t/)[1]
        Purchase.first.item.price == line.strip.split(/\t/)[2]
      end      

      it 'should create a purchase with the merchant from the line' do
        Purchase.first.merchant.address == line.strip.split(/\t/)[4]
        Purchase.first.merchant.name == line.strip.split(/\t/)[5]
      end      

      it 'should create a purchase with the correct purchase count' do
        Purchase.first.purchase_count == line.strip.split(/\t/)[3]
      end
    end
  end

  describe '#gross_revenue' do
    before :each do
      Purchase.destroy_all
      Merchant.destroy_all
      Purchaser.destroy_all
      Item.destroy_all
      purchase_datum.parse!(line)      
    end

    it 'should sum up the purchases in a given purchase datum' do
      purchase_datum.gross_revenue.should == 20.0
    end
  end
end
