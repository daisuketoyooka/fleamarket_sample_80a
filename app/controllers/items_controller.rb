class ItemsController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  before_action :set_item, only: [:show, :destroy, :edit, :update]

  def index
    @items = Item.limit(5).where(buyer_id: nil).order("id DESC")
    @categories = Category.all
    @parents = Category.where(ancestry: nil)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def new
    @item = Item.new
    @category_parent_array = ["---"]
    @category_parent_array = Category.where(ancestry: nil)
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: '出品が完了しました'
    else
      redirect_to new_item_path, alert: '必須項目を入力してください'
    end
  end

  def show
  end

  def destroy
    if @item.destroy
      redirect_to root_path, notice: '商品を削除しました'
    else
      redirect_to item_path(@item.id), alert: 'エラーが発生しました'
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :status, :freight, :shipment_source, :ship_date, :price, :brand, :size, :buyer_id, :category_id, images: []).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def get_category_children
    @category_children = Category.find(params[:parent_id]).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find(params[:child_id]).children
  end
end
