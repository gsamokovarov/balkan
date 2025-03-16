require "rails_helper"

RSpec.case "Admin Giveaway", type: :feature do
  test "admin can create a single free ticket", js: true do
    event = create :event, :balkan2025
    create(:ticket_type, :free, event:)

    setup_and_login_user

    visit admin_event_tickets_path(event)

    click_button "Giveaway"

    within "#giveaway_dialog" do
      fill_in "Name", with: "Jane Doe"
      fill_in "Email", with: "jane@example.com"
      select "M", from: "Shirt size"

      fill_in "Reason", with: "Conference speaker"

      click_button "Create Tickets"
    end

    assert_have_content page, "1 free tickets created successfully"

    order = Order.last
    assert_eq order.free, true
    assert_eq order.free_reason, "Conference speaker"

    ticket = Ticket.last
    assert_eq ticket.name, "Jane Doe"
    assert_eq ticket.email, "jane@example.com"
    assert_eq ticket.shirt_size, "M"
    assert_eq ticket.ticket_type.name, "Free"
    assert_eq ticket.price, 0
  end

  test "admin can create multiple free tickets", js: true do
    event = create :event, :balkan2025
    create(:ticket_type, :free, event:)

    setup_and_login_user

    visit admin_event_tickets_path(event)

    click_button "Giveaway"

    within "#giveaway_dialog" do
      fill_in "Name", with: "Jane Doe"
      fill_in "Email", with: "jane@example.com"
      select "M", from: "Shirt size"

      click_button "Add Ticket"

      within all(".space-y-3")[1] do
        fill_in "Name", with: "John Smith"
        fill_in "Email", with: "john@example.com"
        select "L", from: "Shirt size"
      end

      click_button "Add Ticket"

      within all(".space-y-3")[2] do
        fill_in "Name", with: "Alice Johnson"
        fill_in "Email", with: "alice@example.com"
        select "S", from: "Shirt size"
      end

      fill_in "Reason", with: "Community partners"

      click_button "Create Tickets"
    end

    assert_have_content page, "3 free tickets created successfully"

    order = Order.last
    assert_eq order.free, true
    assert_eq order.free_reason, "Community partners"
    assert_eq order.tickets.count, 3

    tickets = order.tickets.order :id

    assert_eq tickets[0].name, "Jane Doe"
    assert_eq tickets[0].email, "jane@example.com"
    assert_eq tickets[0].shirt_size, "M"

    assert_eq tickets[1].name, "John Smith"
    assert_eq tickets[1].email, "john@example.com"
    assert_eq tickets[1].shirt_size, "L"

    assert_eq tickets[2].name, "Alice Johnson"
    assert_eq tickets[2].email, "alice@example.com"
    assert_eq tickets[2].shirt_size, "S"
  end

  test "admin can remove tickets from the form", js: true do
    event = create :event, :balkan2025
    create(:ticket_type, :free, event:)

    setup_and_login_user

    visit admin_event_tickets_path(event)

    click_button "Giveaway"

    within "#giveaway_dialog" do
      fill_in "Name", with: "Jane Doe"
      fill_in "Email", with: "jane@example.com"
      select "M", from: "Shirt size"

      click_button "Add Ticket"

      within all(".space-y-3")[1] do
        fill_in "Name", with: "John Smith"
        fill_in "Email", with: "john@example.com"
        select "L", from: "Shirt size"
      end

      click_button "Add Ticket"

      within all(".space-y-3")[2] do
        fill_in "Name", with: "To Be Removed"
        fill_in "Email", with: "remove@example.com"
        select "XL", from: "Shirt size"

        find("button[data-action='appendable#remove']").click
      end

      assert_no_text "To Be Removed"
      assert_no_text "remove@example.com"

      fill_in "Reason", with: "Partial giveaway"

      click_button "Create Tickets"
    end

    assert_have_content page, "2 free tickets created successfully"

    order = Order.last
    assert_eq order.tickets.count, 2

    tickets = order.tickets.order :id

    assert_eq tickets[0].name, "Jane Doe"
    assert_eq tickets[1].name, "John Smith"
  end

  test "displays an error when no free ticket type exists", js: true do
    event = create :event, :balkan2025

    setup_and_login_user

    visit admin_event_tickets_path(event)

    click_button "Giveaway"

    within "#giveaway_dialog" do
      fill_in "Name", with: "Jane Doe"
      fill_in "Email", with: "jane@example.com"
      select "M", from: "Shirt size"

      click_button "Create Tickets"
    end

    assert_have_content page, "Error creating tickets: Couldn't find TicketType"

    assert_eq Order.count, 0
    assert_eq Ticket.count, 0
  end

  test "validates required fields", js: true do
    event = create :event, :balkan2025
    create(:ticket_type, :free, event:)

    setup_and_login_user

    visit admin_event_tickets_path(event)

    click_button "Giveaway"

    within "#giveaway_dialog" do
      click_button "Create Tickets"
    end

    assert_eq Order.count, 0
    assert_eq Ticket.count, 0
  end

  test "uses default reason when none is provided", js: true do
    event = create :event, :balkan2025
    create(:ticket_type, :free, event:)

    setup_and_login_user

    visit admin_event_tickets_path(event)

    click_button "Giveaway"

    within "#giveaway_dialog" do
      fill_in "Name", with: "Jane Doe"
      fill_in "Email", with: "jane@example.com"
      select "M", from: "Shirt size"

      fill_in "Reason", with: ""

      click_button "Create Tickets"
    end

    assert_have_content page, "1 free tickets created successfully"

    order = Order.last
    assert_eq order.free_reason, "Giveaway"
  end

  def setup_and_login_user
    create :user, name: "Admin", email: "admin@example.com", password: "admin"

    visit admin_root_path

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "admin"
    click_button "Sign in"

    assert_have_content page, "Current event"
  end
end
