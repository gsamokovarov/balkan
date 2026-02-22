require "rails_helper"

RSpec.case Admin::Workingset do
  let(:event) { create :event, :balkan2024 }
  let(:proposals) { create_list :proposal, 5, event: }
  let(:scope) { Proposal.where(id: proposals.map(&:id)).order(id: :asc) }

  test ".for returns nil when record is not in the scope" do
    other = create(:proposal, event:)

    assert_eq Admin::Workingset.for(other, in: scope), nil
  end

  test "#position returns 1-based index" do
    workingset = Admin::Workingset.for proposals[2], in: scope

    assert_eq workingset.position, 3
  end

  test "#total returns the number of records in the scope" do
    workingset = Admin::Workingset.for proposals[0], in: scope

    assert_eq workingset.total, 5
  end

  test "#prev returns the previous record id" do
    workingset = Admin::Workingset.for proposals[2], in: scope

    assert_eq workingset.prev, proposals[1].id
  end

  test "#prev returns nil for the first record" do
    workingset = Admin::Workingset.for proposals[0], in: scope

    assert_eq workingset.prev, nil
  end

  test "#next returns the next record id" do
    workingset = Admin::Workingset.for proposals[2], in: scope

    assert_eq workingset.next, proposals[3].id
  end

  test "#next returns nil for the last record" do
    workingset = Admin::Workingset.for proposals[4], in: scope

    assert_eq workingset.next, nil
  end
end
