class OwnerController < ApplicationController
    skip_before_action :ensure_user_logged_in
    def index
        render "index"
    end
    def user
      render "user"
    end
    def clerk
        render "clerk"
    end
    def sales
        render "sales"
    end
    def menus
        render "menus"
    end
    def order
        render "orders"
    end
    def report
        user = params[:user]
        u=User.find_by_name(user)
        from = Date.parse(params[:from]) unless params[:from].blank?
        to = Date.parse(params[:to]) unless params[:to].blank?
        if user.blank?
          @orders = Order.where("date >= ? AND date <= ?", from, to)
        elsif from.blank? && to.blank?
          @orders = Order.where("user_id = ?", u.id)
        elsif user.blank? && from.blank? && to.blank?
          @orders = Order.all
        else
          @orders = Order.where("date >= ? AND date <= ? AND user_id = ?", from, to, u.id)
        end
        render "report"
    end

    def invoice
      id= params[:id]
      @order=Order.find(id)
      render "invoice"
      
    end
    def new
      user = User.new(
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        password: params[:password],
        role:"clerk"
      )
      if user.save
        flash[:session] = params[:first_name].capitalize + " Added"
        redirect_to clerklist_path
      end
    end

    def destroy
      id=params[:id]
      clerk=User.find(id)
      clerk.destroy
      redirect_to "/clerklist"
    end

    def create
      new_category = Category.new(name: params[:category].capitalize)
      if new_category.save
        redirect_to owner_path
      else
      end
    end
  def active
    id=params[:id]
    m=Menu.active().first
    m.active_menu=false
    m.save!
    newm=Menu.find(id)
    newm.active_menu= true
    newm.save!
    render"menus"
end

  end