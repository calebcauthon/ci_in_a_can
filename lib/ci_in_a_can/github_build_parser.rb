module CiInACan

  class GithubBuildParser

    def parse content
      payload = extract_payload_from content
      project = extract_repo_from payload

      CiInACan::Build.new(git_ssh: "git@github.com:#{project}.git",
                          repo:    project,
                          sha:     extract_sha_from(payload))
    end

    private

    def extract_repo_from payload
      username, project_name = get_username_and_project_name_from payload
      "#{username}/#{project_name}"
    end

    def extract_payload_from content
      data = JSON.parse content
      JSON.parse data['payload']
    end

    def get_username_and_project_name_from payload
      splat = payload['compare'].split('/')
      [splat[3], splat[4]]
    end

    def extract_sha_from payload
      payload['head_commit']['id']
    end

  end
end
