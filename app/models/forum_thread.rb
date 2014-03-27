class ForumThread < ActiveRecord::Base
  extend InterestingChecker
  has_many :posts
  scope :to_scrape, -> { where(to_scrape: true)}
  scope :to_page_tracked, -> { where(to_page_track: true, marked_as_fast_growing_at: nil)}
  scope :fast_growing, -> { where('marked_as_fast_growing_at IS NOT NULL').order(marked_as_fast_growing_at: :desc)}
  serialize :page_counts, Array
  validates :link, uniqueness: true
  MAX_PAGE_TRACK_OBSERVATIONS = 1500
  GROWTH_THRESHOLDS = [[2, 5], [3, 10], [4, 24], [5, 100]] # for [x, y], we define its fast growing if it jumps x pages in 5*y minutes
  
  def interesting_date
    marked_as_fast_growing_at
  end
  
  def scrape
    posts_hash = extract_posts_from_page(self.last_page_scraped)
    
    if !Post.find_by_uid posts_hash.last[:uid]
      posts.create posts_hash
    end

    fetch_next_page
  end

  def fetch_next_page
    posts_hash = extract_posts_from_page(self.last_page_scraped + 1)
    if !Post.find_by_uid posts_hash.first[:uid]
      posts.create posts_hash
      self.increment! :last_page_scraped
      fetch_next_page
    end
  end

  def extract_posts_from_page(page)
    url = self.link.gsub /{page_number}/, page.to_s
    doc = Nokogiri::HTML(open(url))
    doc.xpath("//script").remove
    doc.css("#posts > div:not(#lastpost)").map do |post|
      {
        username: post.css(".bigusername").text,
        link: post.css("td.thead a").to_s.scan(/href=\"(.*?)\"/).first.first,
        uid: post.css("td.thead a").text.to_i,
        body: post.css("td.alt1 > div:not(.smallfont)").text.strip
      }
    end
  end

  def self.get_new_forum_threads
    feeds = ["http://www.flyertalk.com/forum/external.php?type=RSS2&forumids=372", "http://www.flyertalk.com/forum/external.php?type=rss2&forumids=627"]
    for feed in feeds
      new_threads = Nokogiri::XML.parse(HTTParty.get(feed).body).xpath('//item')
      for thread in new_threads
        record = ForumThread.create name: thread.xpath('title').first.text, link: thread.xpath('link').first.text, to_page_track: true
        if record.persisted? and (ForumThread.is_interesting?(thread.xpath('title').first.text) or ForumThread.is_interesting?(thread.xpath('description').first.text))
          record.marked_as_fast_growing_at = Time.now
          record.save
        end
      end
    end
  end


  def log_page_count
    # delete if thread is too old
    if self.page_counts.length > MAX_PAGE_TRACK_OBSERVATIONS
      self.destroy
      return
    end

    vb_controls = Nokogiri::HTML.parse(HTTParty.get(self.link).body).css('.pagenav .vbmenu_control')
    if vb_controls.length == 0
      self.page_counts << 1
    else
      self.page_counts << vb_controls.first.text.split(' ').last.to_i
    end
   
    # decide whether we have to mark it as fast growing
    self.marked_as_fast_growing_at = Time.now if fast_growing?
    self.save
    
    
  end

  # determine whether we ever jump 
  def fast_growing?
    to_mark = false
    for page, interval in GROWTH_THRESHOLDS
      to_mark ||= cross_growth_threshold(page, interval)
    end
    to_mark
  end

  def cross_growth_threshold(page, interval)
    max = 0
    for i in (0..(page_counts.length - interval - 1)).to_a
      diff = page_counts[i+interval] - page_counts[i]
      max = diff if diff > max and diff >= page
    end
    max > 0
  end 
end
