class ForumThread < ActiveRecord::Base
  has_many :posts
  scope :to_scrape, -> { where(to_scrape: true)}
  scope :to_page_track, -> { where(to_page_track: true)}
  serialize :page_counts, Array

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
        ForumThread.create name: thread.xpath('title').first.text, link: thread.xpath('link').first.text, to_page_track: true
      end
    end
  end

  def log_page_count
    vb_controls = Nokogiri::HTML.parse(HTTParty.get(self.link).body).css('.pagenav .vbmenu_control')
    if vb_controls.length == 0
      self.page_counts << 1
    else
      self.page_counts << vb_controls.first.text.split(' ').last.to_i
    end
    self.save

  end

end
