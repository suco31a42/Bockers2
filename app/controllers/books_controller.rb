class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      from = 1.week.ago.beginning_of_day
      to = Time.current.end_of_day
      @books = Book.left_outer_joins(:favorites)
                 .where(favorites: { created_at: from..to })
                 .order(favorites_count: :desc)
                 .includes(:user)
                 .or(Book.left_outer_joins(:favorites)
                         .where(favorites: { id: nil }))
      @today_book =  Book.created_today
      @yesterday_book = Book.created_yesterday
      @this_week_book = Book.created_this_week
      @last_week_book = Book.created_last_week
      render 'index'
    end
  end

  def index
    @book  = Book.new
    from = 1.week.ago.beginning_of_day
    to = Time.current.end_of_day
    @books = Book.left_outer_joins(:favorites)
                  .where(favorites: { created_at: from..to })
                  .order(favorites_count: :desc)
                  .includes(:user)
                  .or(Book.left_outer_joins(:favorites)
                          .where(favorites: { id: nil }))
    @today_book =  Book.created_today
    @yesterday_book = Book.created_yesterday
    @this_week_book = Book.created_this_week
    @last_week_book = Book.created_last_week
  end

  def show
    @bookid = Book.find(params[:id])
    @book = Book.new
    @user = @bookid.user
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to '/books', notice: "Post deleted"
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :star)
  end


  def is_matching_login_user
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_path
    end
  end

end
