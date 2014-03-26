class LinksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def log
    par = request.body.read
    title = par.split("::::").first
    link = par.split("::::").last
    link = Link.new name: title, link: link
    link.save if link.is_interesting?
    render text: (link.persisted? ? "Interesting" : "Not Interesting")
  end
end
