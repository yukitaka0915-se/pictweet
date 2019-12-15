class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :show, :update, :destroy]
  before_action :check_currentuser, only: [:update, :destroy]
  before_action :move_to_index, except: [:index]

  def index
    @tweets = Tweet.includes(:user).page(params[:page]).per(5).order("created_at DESC")
  end

  def new
    @tweet = Tweet.new
  end

  def create
    Tweet.create(tweet_params)
  end

  def destroy
    @tweet.destroy if is_currentuser
  end

  def edit
  end

  def update
    @tweet.update(tweet_params) if is_currentuser
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end

  private
  def tweets_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def check_currentuser
    is_currentuser = @tweet.user_id == current_user.id
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end
end