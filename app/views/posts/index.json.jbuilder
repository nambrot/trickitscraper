json.array!(@posts) do |post|
  json.extract! post, :uid, :body, :username, :link
  json.url post_url(post, format: :json)
end
