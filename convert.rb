require 'nokogiri'
require 'json'
require 'cgi'

def comment_to_json(post, comment)
  name = comment.at_css('name').content
  return {
    id: "idb_#{comment.get_attribute('id')}",
    pid: "idb_#{comment.get_attribute('parentid')}",
    text: "<p>#{comment.at_css("text").content}</p>",
    user: {
        name: name,
        id: "idb_#{name.gsub(" ", "_")}",
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

input_file = ARGV[0]

raise ArgumentError.new("pass input file name") if input_file.nil?

doc = Nokogiri::XML(open(input_file))
posts = doc.css('blogpost')

output = []

for post in posts
  comments = post.css('comment')
  output << comments.map { |comment| comment_to_json(post, comment) }
end

output.flatten!

puts output.to_json
