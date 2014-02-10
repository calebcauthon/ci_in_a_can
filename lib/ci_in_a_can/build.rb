module CiInACan

  class Build

    attr_accessor :git_ssh, :local_location, :repo, :sha
    attr_accessor :pre_test_commands
    attr_accessor :id

    def initialize
      self.pre_test_commands = []
    end

    def self.parse content
      data = JSON.parse content
      data['payload'] = JSON.parse data['payload']

      splat = data['payload']['compare'].split('/')

      build = self.new
      build.git_ssh = "git@github.com:#{splat[3]}/#{splat[4]}.git"
      build.repo    = "#{splat[3]}/#{splat[4]}"
      build.sha     = data['payload']['head_commit']['id']
      build.pre_test_commands = []
      build
    end

  end

end
