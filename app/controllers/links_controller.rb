class LinksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def log
    par = JSON.parse request.body.read
    link = Link.new title: par["title"], link: par["url"]
    link.save if link.is_interesting?
    render text: (link.persisted? ? "Interesting" : "Not Interesting")
  end
end
