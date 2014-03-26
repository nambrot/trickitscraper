class PagesController < ApplicationController
  before_filter :interesting_stuff
  def index
  end
  def notification_feed
    respond_to do |format|
      format.atom { render :layout => false }

      # we want the RSS feed to redirect permanently to the ATOM feed
      format.rss { render :layout => false, :file => 'pages/notification_feed.atom.builder' }
    end
  end

  def interesting_stuff
    fast_growing_threads = ForumThread.fast_growing.to_enum(:find_each_with_order, property_key: :marked_as_fast_growing_at, direction: :desc)
    links = Link.order(created_at: :desc).to_enum(:find_each_with_order, property_key: :created_at, direction: :desc)
    @interesting_stuff = ActivityAggregator.new([fast_growing_threads, links]).
          next_activities(50)
  end
end
