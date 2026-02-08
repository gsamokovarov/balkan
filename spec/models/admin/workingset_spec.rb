require "rails_helper"

RSpec.case Admin::Workingset do
  let(:event) { create :event, :balkan2024 }
  let(:proposals) { create_list :proposal, 5, event: }
  let(:scope) { Proposal.where(id: proposals.map(&:id)).order(id: :asc) }

  test "#position returns 1-based index" do
    workingset = Admin::Workingset.new scope, proposals[2]

    assert_eq workingset.position, 3
  end

  test "#total returns the number of records in the scope" do
    workingset = Admin::Workingset.new scope, proposals[0]

    assert_eq workingset.total, 5
  end

  test "#prev returns the previous record id" do
    workingset = Admin::Workingset.new scope, proposals[2]

    assert_eq workingset.prev, proposals[1].id
  end

  test "#prev returns nil for the first record" do
    workingset = Admin::Workingset.new scope, proposals[0]

    assert_eq workingset.prev, nil
  end

  test "#next returns the next record id" do
    workingset = Admin::Workingset.new scope, proposals[2]

    assert_eq workingset.next, proposals[3].id
  end

  test "#next returns nil for the last record" do
    workingset = Admin::Workingset.new scope, proposals[4]

    assert_eq workingset.next, nil
  end

  test "raises when current record is not in the scope" do
    other = create(:proposal, event:)

    assert_raise Precondition::Error do
      Admin::Workingset.new scope, other
    end
  end
end
