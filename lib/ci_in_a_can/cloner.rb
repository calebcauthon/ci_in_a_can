module CiInACan
  module Cloner
    def self.clone_a_local_copy_for build
      CiInACan::Bash.run "git clone #{build.git_ssh} #{build.local_location}; cd #{build.local_location}; git checkout #{build.sha}"
    end
  end
end
