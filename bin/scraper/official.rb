#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class String
  def ztidy
    gsub(/[\u200B-\u200D\uFEFF]/, '').tidy
  end
end

class MemberList
  class Member
    def name
      lines[1].gsub(/the hon /i, '')
    end

    def position
      lines.drop(2)
    end

    private

    def lines
      noko.css('td').xpath('.//text()').map(&:text).map(&:ztidy).reject(&:empty?)
    end
  end

  class Members
    def member_container
      noko.css('.ms-rteTable-2 tr')
    end

    def member_items
      super.reject { |mem| mem.name == 'Port Louis' }
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
