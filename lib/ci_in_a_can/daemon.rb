module CiInACan

  module Daemon

    def self.start options
      CiInACan.site_url = options[:site_url]
      CiInACan::Github.access_token = options[:access_token]
      CiInACan::Watcher.watch options[:watching_location], options[:working_location]

      sleep
    end

  end

end
