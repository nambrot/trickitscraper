require 'clockwork'
include Clockwork
require File.expand_path('../boot', __FILE__)
require File.expand_path('../environment', __FILE__)
 
every(2.minutes, 'fetch scrape threads') { ForumThread.to_scrape.all.each {|thread| thread.scrape } }
every(5.minutes, 'fetch MR threads') { ForumThread.get_new_forum_threads }
every(5.minutes, 'get page counts of threads') { ForumThread.to_page_tracked.each {|thread| thread.log_page_count } }