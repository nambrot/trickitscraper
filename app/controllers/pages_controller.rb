class PagesController < ApplicationController
  def index
    @fast_growing_threads = ForumThread.fast_growing
  end
end
