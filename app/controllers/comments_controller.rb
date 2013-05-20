class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @comment = User.find(current_user.id).comments.new params[:comment]

    url = "https://graph.facebook.com/oauth/access_token?client_id=#{FB['key']}&client_secret=#{FB['secret']}&grant_type=authorization_code&redirect_uri=http://localhost:3001"
    
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body

    respond_to do |format|
      if @comment.save
        format.json { render :json => {id: current_user.id, name: current_user.name,
          uid: current_user.uid, token: session['token']} } 
      else
        format.json { render :json => @comment.errors.full_messages.to_sentence } #output javascript messages
      end   
    end
  end

  def destroy
    @comment = Comment.find(params[:id]) 
    if @comment.destroy
      head :no_content
    else
      render :json => {error: I18n.t('.comments.errors.destroy')}
    end
  end
end
