require_relative '../spec_helper'

describe CiInACan::Github do

  describe "client" do

    describe "when an access token was provided" do

      let(:access_token) { Object.new }

      it "should create an Octokit client with the access token" do
        client       = Object.new

        CiInACan::Github.access_token = access_token

        Octokit::Client.expects(:new).with(access_token: access_token).returns client

        CiInACan::Github.client.must_be_same_as client
      end

    end

    describe "when an access token was not provided" do

      let(:access_token) { nil }

      it "should return nothing" do
        CiInACan::Github.access_token = access_token

        Octokit::Client.expects(:new).never

        CiInACan::Github.client.nil?.must_equal true
      end

    end

  end

  describe "report_pending_status" do

    it "should report a pending status to the github client" do

      build = CiInACan::Build.new
      build.sha  = Object.new
      build.repo = Object.new

      client = Object.new
      CiInACan::Github.stubs(:client).returns client

      client.expects(:create_status).with build.repo, build.sha, 'pending'

      CiInACan::Github.report_pending_status_for build
    end

    it "should not fail if there is no github client" do
      CiInACan::Github.stubs(:client).returns nil
      CiInACan::Github.report_pending_status_for CiInACan::Build.new
    end

  end

  describe "report_complete_status" do

    describe "a successful test result" do

      let(:test_result) do
        test_result = Object.new
        test_result.stubs(:passed).returns true
        test_result
      end

      it "should report a success status to the github client" do
        build = CiInACan::Build.new
        build.sha  = Object.new
        build.repo = Object.new

        client = Object.new
        CiInACan::Github.stubs(:client).returns client

        client.expects(:create_status).with build.repo, build.sha, 'success'

        CiInACan::Github.report_complete_status_for build, test_result
      end

    end

    describe "a failed test result" do

      let(:test_result) do
        test_result = Object.new
        test_result.stubs(:passed).returns false
        test_result
      end

      it "should report a success status to the github client" do
        build = CiInACan::Build.new
        build.sha  = Object.new
        build.repo = Object.new

        client = Object.new
        CiInACan::Github.stubs(:client).returns client

        client.expects(:create_status).with build.repo, build.sha, 'failure'

        CiInACan::Github.report_complete_status_for build, test_result
      end

    end

    it "should not fail if there is no github client" do
      CiInACan::Github.stubs(:client).returns nil
      CiInACan::Github.report_complete_status_for CiInACan::Build.new, Object.new
    end

  end

end
