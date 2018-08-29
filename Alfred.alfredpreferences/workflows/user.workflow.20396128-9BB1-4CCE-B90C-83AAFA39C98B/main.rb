#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require_relative "bundle/bundler/setup"
require "alfred"
require 'json'

basic_user     = ENV['BB_USER_NAME']
basic_password = ENV['BB_PASSWORD']
cache = "/tmp/bb-repositories.json"

Alfred.with_friendly_error do |alfred|
  alfred.with_rescue_feedback = true
  fb = alfred.feedback

  if File.exists?(cache) and File.stat(cache).mtime > Time.now - 60*60*2
    j = File.read(cache)
  else
    j = `curl --silent --user #{basic_user}:#{basic_password} https://bitbucket.org/api/1.0/user/repositories`
    File.write(cache, j)
  end
  added = []
  JSON.load(j).sort_by{|o| o['name']}.each do |o|
    name = o['name']
    next if added.include? name
    added << name
    url = "https://bitbucket.org/#{basic_user}/#{name}"
    fb.add_item({
      :uid      => "",
      :title    => "#{name}",
      :subtitle => "#{o['description']} #{url}",
      :arg      => url.gsub(" ", "-").downcase,
      :valid    => "yes",
    })
  end

  if ARGV[0].eql? "failed"
    alfred.with_rescue_feedback = true
    raise Alfred::NoBundleIDError, "Wrong Bundle ID Test!"
  end

  puts fb.to_xml(ARGV)
end
