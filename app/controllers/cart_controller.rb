class CartController < ApplicationController
    def index
        render "index"
    end
    def new
        items = JSON.parse(cookies[:items])
        totalcost = JSON.parse(cookies[:cost])
        customerName = cookies[:customer]
        if customerName.nil? || customerName.empty? 
            order = Order.create!(
                cost: totalcost, 
                date: Date.today, 
                user_id: @current_user.id,
                delivered_status: false,
                customer: @current_user.first_name
            )
        else
            order = Order.create!(
            cost: totalcost, 
            date: Date.today, 
            user_id: @current_user.id,
            delivered_status: false,
            customer: customerName.capitalize
            )
        end
        items.each do |item|
            OrderItem.create!(order_id: order.id, menu_id: item["id"], item_name: item["item_name"], item_price: item["price"], incart: item["incart"])
        end
        flash[:session] = "Order Confirm" 
        redirect_to "/menus"
    end

    def show
        order = Order.find(params[:id])
        order_json={}
        order_json["total"] = order.cost
        order_json["Date"] = order.created_at.to_s(:short)
        order_json["updated"] = order.updated_at.to_s(:short)
        order_json["items"] = order.order_items
        render json: order_json
    end

end