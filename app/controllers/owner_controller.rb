class OwnerController < ApplicationController
    skip_before_action :ensure_user_logged_in
    before_action :check_owner
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
      @o=Order.all 
      @p=@o.map{|item| item.cost}
        render "sales"
    end
    def menus
        render "menus"
    end
    def order
        render "orders"
    end
    
    def delete
      id = params[:category]
      category=Category.find(id)
      category.menu_items.delete_all
      flash[:session] = category.name.capitalize + " Deleted"
      category.destroy
      redirect_to owner_index_path
    end

    def report
        user = params[:user]
        u=User.find(user) unless params[:user].blank?
        from = Date.parse(params[:from]) unless params[:from].blank?
        to = Date.parse(params[:to]) unless params[:to].blank?
        if user.blank? && from.blank? && to.blank?
          @orders = Order.sort_date
        else
          if user.blank?
            if from.blank? || to.blank?
              @orders = Order.sort_date
            else
              @orders = Order.where("date >= ? AND date <= ?", from, to).sort_date
            end
          else
            if from.blank? || to.blank?
              @orders = Order.where("user_id = ?", u.id).sort_date
            else
              @orders = Order.where("date >= ? AND date <= ? AND user_id = ?", from, to, u.id).sort_date
            end
          end
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
      redirect_to clerklist_path
    end

    def create
      new_category = Category.new(name: params[:category].capitalize)
      flash[:session] = new_category.name.capitalize + " Added"
      if new_category.save
        redirect_to owner_index_path
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