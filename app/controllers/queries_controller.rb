class QueriesController < ApplicationController

before_action :load_user, only: [:index, :create, :show]

def index
    @query = Query.where(user_id: params[:user_id])
    #@query = Query.all
    @result = @query
    
    @arr=[]
    i=0
    while i < @result.length 
       string = @result[i].q_string
       @api = get_data(string)
       @arr << @api
         i += 1
    end

end


def new
    @query = Query.new
    render(:new)
end

  def create
    @query = @user.queries.new(title: params[:title], q_string: create_string(params[:title], params[:zip], params[:beds], params[:baths]))
    if @query.save
      redirect_to user_path(@user)
    else
      render(:new)
    end
  end

  def show
    @query = Query.find(params[:id])
    @result = @query
    @result = @result.q_string 
    @api = get_data(@result)
  end

  def destroy
    @query = Query.find_by(id: params[:id])
    @query.destroy
    redirect_to root_path
  end

  private

  def load_user
    return @user = User.find(params[:user_id])
  end

  def get_data(result)
    from_streeteasy = HTTParty.get(result)
    return from_streeteasy
  end

  def create_string(title, zip, beds, baths)
    return "http://streeteasy.com/nyc/api/#{title}/data?criteria=zip:#{zip}%7Cbeds:#{beds}%7Cbaths:#{baths}&key=#{STREETEASY_CLIENT_ID}&format=json"
  end

end