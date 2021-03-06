require_relative '../spec_helper'

describe CiInACan::TestRunner do

  after { ::Timecop.return }

  it "should default created_at to now" do
    now = Time.now
    ::Timecop.freeze now
    CiInACan::TestResult.new.created_at.must_equal now
  end

  it "should allow the created_at to be set" do
    now = Object.new
    test_result = CiInACan::TestResult.new(created_at: now)
    test_result.created_at.must_be_same_as now
  end

  describe "create" do
    it "should set a unique id" do
      id   = Object.new
      uuid = Object.new

      UUID.stubs(:new).returns uuid
      uuid.expects(:generate).returns id

      test_result = CiInACan::TestResult.create({})

      test_result.id.must_be_same_as id
    end
  end

  describe "create and find" do

    describe "a simple example" do

      it "should be able to store and retrieve a result" do

        original_test_result  = CiInACan::TestResult.create({})
        retrieved_test_result = CiInACan::TestResult.find original_test_result.id

        original_test_result.id.must_equal retrieved_test_result.id

      end

      it "should be persist values" do

        values = { passed: true, output: 'some output' }
        original_test_result  = CiInACan::TestResult.create(values)
        retrieved_test_result = CiInACan::TestResult.find original_test_result.id

        retrieved_test_result.contrast_with! values

      end

    end

    describe "a more complicated example" do

      it "should be able to store and retrieve a result" do

        # save more records
        CiInACan::TestResult.create({})
        CiInACan::TestResult.create({})
        original_test_result  = CiInACan::TestResult.create({})
        CiInACan::TestResult.create({})
        CiInACan::TestResult.create({})

        retrieved_test_result = CiInACan::TestResult.find original_test_result.id

        original_test_result.id.must_equal retrieved_test_result.id

      end

    end

    describe "to_json" do

      let(:fields) do
        [:id, :passed, :output, :created_at]
      end

      it "should return json that contains the values" do
        uuid = ::UUID.new
        values = fields.reduce({}) { |t, i| t[i] = uuid.generate; t }

        test_result = CiInACan::TestResult.new values

        json = JSON.parse(test_result.to_json)

        fields.each { |f| json[f.to_s].must_equal values[f] }
      end

    end

  end

end
