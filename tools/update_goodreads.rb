#!/usr/bin/env ruby
# frozen_string_literal: true

require "net/http"
require "rexml/document"
require "time"
require "uri"
require "yaml"

FEED_URL = "https://www.goodreads.com/review/list_rss/151402161?shelf=read"
OUTPUT_PATH = File.expand_path("../_data/goodreads_books.yml", __dir__)

def fetch_feed
  uri = URI(FEED_URL)
  connection = Net::HTTP.new(uri.host, uri.port)
  connection.use_ssl = true
  connection.open_timeout = 5
  connection.read_timeout = 15

  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = "lucaa2000.github.io Goodreads data updater"
  response = connection.request(request)
  raise "Goodreads returned HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

  response.body
end

def text(item, element)
  item.elements[element]&.text&.strip
end

def https_url(value)
  uri = URI.parse(value.to_s)
  value if uri.is_a?(URI::HTTPS)
rescue URI::InvalidURIError
  nil
end

source_path = ARGV.first
xml = source_path ? File.read(source_path) : fetch_feed
document = REXML::Document.new(xml)

books = REXML::XPath.match(document, "//item").filter_map do |item|
  title = text(item, "title")
  author = text(item, "author_name")
  link = https_url(text(item, "link"))
  next if title.nil? || title.empty? || author.nil? || author.empty? || link.nil?

  rating = Integer(text(item, "user_rating") || 0, exception: false).to_i.clamp(0, 5)

  {
    "title" => title,
    "author" => author,
    "link" => link,
    "image_url" => https_url(text(item, "book_large_image_url") || text(item, "book_image_url")),
    "rating" => rating,
    "date_read" => text(item, "user_read_at")
  }.compact
end

raise "Goodreads feed did not contain any valid books" if books.empty?

books.sort_by! do |book|
  date_read = book["date_read"]
  date_read ? Time.parse(date_read) : Time.at(0)
rescue ArgumentError
  Time.at(0)
end
books.reverse!

temporary_path = "#{OUTPUT_PATH}.tmp"
File.write(temporary_path, YAML.dump(books))
File.rename(temporary_path, OUTPUT_PATH)
puts "Updated #{OUTPUT_PATH} with #{books.length} books."
