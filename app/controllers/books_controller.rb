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
      @books = Book.includes(:favorited_users).
        sort_by {|x|
          x.favorited_users.includes(:favorites).where(created_at: from...to).size
        }.reverse
      render 'index'
    end
  end

  def index
    @book  = Book.new
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.left_outer_joins(:favorited_users)
                .group('books.id')
                .order('COUNT(favorites.id) DESC')
                .select('books.*, COUNT(favorites.id) as favorites_count')
                .where('favorites.created_at >= ?', from)
                .where('favorites.created_at <= ?', to )
                .or(Book.left_outer_joins(:favorited_users)
                        .where(favorites: {id: nil}))
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
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_path
    end
  end

end
