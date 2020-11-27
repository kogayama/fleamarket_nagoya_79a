class ItemsController < ApplicationController
  def index
    @items = Item.order('id DESC').limit(5).where.not(seller_id: current_user&.id)
    @my_items = Item.where(seller_id: current_user&.id).limit(5)

  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
    @item.item_images.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
    @item.item_images.build
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to item_path(@item.id)
    else
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to root_path
  end

  def  done
    @item= Item.find(params[:id])
    @item.update( buyer_id: current_user.id)
  end

  private

  def item_params
    params.require(:item).permit(:name, :introduction, :price, :category_id, :brand, :condition_id, :shipping_date_id, :delivery_source_area_id, :postage_id, item_images_attributes: [:src, :id]).merge(seller_id: current_user.id)
  end

end
