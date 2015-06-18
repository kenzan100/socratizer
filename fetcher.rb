require 'httparty'
require 'pp'

class Fetcher
  attr_accessor :res
  def initialize(id)
    @url = "https://spreadsheets.google.com/feeds/list/" + id + "/od6/public/values?alt=json"
  end

  def fetch
    @res = HTTParty.get(@url)
  end

  def length
    @res["feed"]["entry"].size
  end

  def each_row(&block)
    @res["feed"]["entry"].each_with_index do |row, i|
      yield(row["title"]["$t"], row["content"]["$t"], i)
    end
  end
end

spreadsheetID = "1JnVV_qVpKfNgiW6IiBuyYXVaSKYS-cr65-OnnG5l7ZI"
fetcher = Fetcher.new(spreadsheetID)
fetcher.fetch

fetcher.each_row do |question, answer, i|
  puts question
  print "君の答え（ノートに書きましょう！）"
  gets
  puts answer
  unless (i+1) == fetcher.length
    gets
  end
end
