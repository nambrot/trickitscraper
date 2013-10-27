class ForumThread < ActiveRecord::Base
  has_many :posts

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
end
