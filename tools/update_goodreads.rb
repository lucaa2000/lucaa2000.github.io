#!/usr/bin/env ruby
# frozen_string_literal: true

require "net/http"
require "rexml/document"
require "time"
require "uri"
require "yaml"

FEEDS = [
  {
    url: "https://www.goodreads.com/review/list_rss/151402161?shelf=read",
    output_path: File.expand_path("../_data/goodreads_books.yml", __dir__),
    date_element: "user_read_at",
    date_key: "date_read"
  },
  {
    url: "https://www.goodreads.com/review/list_rss/151402161?shelf=currently-reading",
    output_path: File.expand_path("../_data/goodreads_currently_reading.yml", __dir__),
    date_element: "user_date_added",
    date_key: "date_added"
  }
].freeze

def fetch_feed(feed_url)
  uri = URI(feed_url)
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

source_paths = ARGV

FEEDS.each_with_index do |feed, index|
  xml = source_paths[index] ? File.read(source_paths[index]) : fetch_feed(feed[:url])
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
      feed[:date_key] => text(item, feed[:date_element])
    }.compact
  end

  raise "Goodreads feed did not contain any valid books" if books.empty?

  books.sort_by! do |book|
    date = book[feed[:date_key]]
    date ? Time.parse(date) : Time.at(0)
  rescue ArgumentError
    Time.at(0)
  end
  books.reverse!

  temporary_path = "#{feed[:output_path]}.tmp"
  File.write(temporary_path, YAML.dump(books))
  File.rename(temporary_path, feed[:output_path])
  puts "Updated #{feed[:output_path]} with #{books.length} books."
end
