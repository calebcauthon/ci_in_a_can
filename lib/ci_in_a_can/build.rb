module CiInACan

  class Build

    attr_accessor :git_ssh, :local_location, :repo, :sha
    attr_accessor :id

    def self.parse content
      payload = extract_payload_from content

      project = extract_repo_from payload
      sha     = extract_sha_from payload

      build = self.new
      build.git_ssh = "git@github.com:#{project}.git"
      build.repo    = project
      build.sha     = sha
      build
    end

    def commands
      ['bundle install', 'bundle exec rake']
    end

    private

    def self.extract_repo_from payload
      username, project_name = get_username_and_project_name_from payload
      "#{username}/#{project_name}"
    end

    def self.extract_payload_from content
      data = JSON.parse content
      JSON.parse data['payload']
    end

    def self.get_username_and_project_name_from payload
      splat = payload['compare'].split('/')
      [splat[3], splat[4]]
    end

    def self.extract_sha_from payload
      payload['head_commit']['id']
    end

  end

end
