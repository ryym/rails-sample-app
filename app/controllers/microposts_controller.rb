class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      # XXX: We can't paginate from this controller
      # because, if do so, paginator send GET request to '/micropost?page=2'.
      # But micropost feed is paginated at `StaticPageController#home`
      # (which serves as a root route like `/?page=2`).
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    # TODO
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
