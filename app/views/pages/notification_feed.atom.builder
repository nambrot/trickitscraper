xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Nam's Deal Notifier"
    xml.description "Notifies you of potentially great fares"

for post in @interesting_stuff
  xml.item do
    xml.title post.name
    xml.description post.name
    xml.pubDate post.interesting_date
    xml.link post.link
   end
end
end
end