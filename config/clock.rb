require 'clockwork'
include Clockwork
require File.expand_path('../boot', __FILE__)
require File.expand_path('../environment', __FILE__)
 
every(2.minutes, 'fetch all threads') { ForumThread.all.each {|thread| thread.scrape } }
