class PagesController < ApplicationController
  def index
    @fast_growing_threads = ForumThread.fast_growing
    @links = Link.order created_at: :desc
  end
end
