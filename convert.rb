require 'nokogiri'
require 'json'

def comment_to_json(post, comment)
  return {
    id: "idb_#{comment.get_attribute('id')}",
    pid: "idb_#{comment.get_attribute('parentid')}",
    text: "<p>#{comment.at_css("text").content}</p>",
    user: {
        name: comment.at_css('name').content,
        id: "",
        picture: "",
        admin: false,
        ip: comment.at_css("ip").content
    },
    locator: {
        site: "radiot",
        url: CGI.unescape(post.at_css('url').content)
    },
    score: comment.at_css('score').content.to_i,
    votes: {},
    time: comment.at_css('gmt').content
  }
end

## ---------------

doc = Nokogiri::XML(open('./input.xml'))
posts = doc.css('blogpost')

output = []

for post in posts
  comments = post.css('comment')
  output << comments.map { |comment| comment_to_json(post, comment) }
end

output.flatten!

File.open('./output.json', 'w') do |f|
  f.write(output.to_json)
end
puts "done"
