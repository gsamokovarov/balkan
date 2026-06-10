require "rails_helper"

RSpec.case "JobPosting" do
  test "relevant while the event is upcoming" do
    job_posting = create :job_posting

    travel_to Time.zone.local(2024, 4, 1, 12, 0, 0) do
      assert_eq job_posting.relevant?, true
    end
  end

  test "relevant within a month after the event ends" do
    job_posting = create :job_posting

    travel_to Time.zone.local(2024, 5, 26, 12, 0, 0) do
      assert_eq job_posting.relevant?, true
    end
  end

  test "not relevant a month after the event ends" do
    job_posting = create :job_posting

    travel_to Time.zone.local(2024, 5, 27, 12, 0, 0) do
      assert_eq job_posting.relevant?, false
    end
  end

  test "not relevant when unpublished" do
    job_posting = create :job_posting, published_at: nil

    travel_to Time.zone.local(2024, 4, 1, 12, 0, 0) do
      assert_eq job_posting.relevant?, false
    end
  end
end
