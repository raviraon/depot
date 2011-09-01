require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new( :title => "title", :description => "desc", :image_url => "abc.gif", :price => -1)

    assert product.invalid?
    assert "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    product.price = 0
    assert product.invalid?
    assert "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(:title => "title", :description => "description", :image_url => image_url, :price => 1)
  end

  test "image_url" do
    ok = %w{one.jpg two.png ONE.JPG Two.JPG http://ss/ss/ss/all.png one.gif}
    bad = %w{one.doc one.png/more fred.jpg.more}

    ok.each do |name|
      assert new_product(name).valid?, "#{name} should not be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should not be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(:title => products(:ruby).title,
                          :description => 'yyy',
                          :image_url => 'abc.png',
                          :price => 4.99)
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end
end