require 'spec_helper'

describe Shop::CheckoutController do
  let(:distributor) { double(:distributor) }
  let(:order_cycle) { create(:order_cycle) }
  let(:order) { create(:order) }
  before do
    order.stub(:checkout_allowed?).and_return true
    controller.stub(:check_authorization).and_return true
  end
  it "redirects home when no distributor is selected" do
    get :edit
    response.should redirect_to root_path
  end

  it "redirects to the shop when no order cycle is selected" do
    controller.stub(:current_distributor).and_return(distributor)
    get :edit
    response.should redirect_to shop_path
  end

  it "redirects to the shop when no line items are present" do
    controller.stub(:current_distributor).and_return(distributor)
    controller.stub(:current_order_cycle).and_return(order_cycle)
    controller.stub(:current_order).and_return(order)
    order.stub_chain(:insufficient_stock_lines, :present?).and_return true
    get :edit
    response.should redirect_to shop_path
  end

  it "renders when both distributor and order cycle is selected" do
    controller.stub(:current_distributor).and_return(distributor)
    controller.stub(:current_order_cycle).and_return(order_cycle)
    controller.stub(:current_order).and_return(order)
    order.stub_chain(:insufficient_stock_lines, :present?).and_return false
    get :edit
    response.should be_success
  end
end