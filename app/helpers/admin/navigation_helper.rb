module Admin::NavigationHelper
  def admin_sections
    @admin_sections ||= {
      ticketing: {
        name: "Ticketing",
        tabs: [
          { name: "Tickets", path: admin_event_tickets_path(Current.event) },
          { name: "Ticket types", path: admin_event_ticket_types_path(Current.event) },
        ],
      },

      program: {
        name: "Program",
        tabs: [
          { name: "Lineup members", path: admin_event_lineup_members_path(Current.event) },
          { name: "Schedule", path: admin_event_schedule_path(Current.event) },
          { name: "Proposals", path: admin_event_proposals_path(Current.event) },
          { name: "Speakers", path: admin_speakers_path, global: true },
          { name: "Talks", path: admin_talks_path, global: true },
        ],
      },

      communications: {
        name: "Communications",
        tabs: [
          { name: "Communication drafts", path: admin_event_communication_drafts_path(Current.event) },
          { name: "Communications", path: admin_event_communications_path(Current.event) },
          { name: "Announcements", path: admin_event_announcements_path(Current.event) },
          { name: "Subscribers", path: admin_subscribers_path },
        ],
      },

      partnerships: {
        name: "Partnerships",
        tabs: [
          { name: "Sponsorship packages", path: admin_event_sponsorship_packages_path(Current.event) },
          { name: "Sponsorships", path: admin_event_sponsorships_path(Current.event) },
          { name: "Community partners", path: admin_event_community_partners_path(Current.event) },
          { name: "Sponsors", path: admin_sponsors_path, global: true },
          { name: "Venues", path: admin_venues_path, global: true },
        ],
      },

      content: {
        name: "Content",
        tabs: [
          { name: "Blog posts", path: admin_event_blog_posts_path(Current.event) },
          { name: "Media Gallery", path: admin_event_media_gallery_path(Current.event) },
          { name: "Embeddings", path: admin_event_embeddings_path(Current.event) },
        ],
      },

      accounting: {
        name: "Accounting",
        tabs: [
          { name: "Orders", path: admin_orders_path },
          { name: "Invoices", path: admin_invoices_path },
          { name: "Invoice sequences", path: admin_invoice_sequences_path },
        ],
      },

      settings: {
        name: "Settings",
        tabs: [
          { name: "Events", path: admin_events_path },
          { name: "Users", path: admin_users_path },
        ],
      },
    }
  end

  def admin_sidebar_links
    first_tab = -> { admin_sections[it][:tabs].first[:path] }

    [
      { header: Current.event.name },
      { name: "Dashboard", path: admin_root_path },
      { name: "Ticketing", path: first_tab[:ticketing], section: :ticketing },
      { name: "Program", path: first_tab[:program], section: :program },
      { name: "Communications", path: first_tab[:communications], section: :communications },
      { name: "Partnerships", path: first_tab[:partnerships], section: :partnerships },
      { name: "Content", path: first_tab[:content], section: :content },
      { header: "Manage" },
      { name: "Accounting", path: first_tab[:accounting], section: :accounting },
      { name: "Settings", path: first_tab[:settings], section: :settings },
    ]
  end

  def section_navigation(section_key)
    admin_sections.fetch(section_key) => { name:, tabs: }

    content_for :section_navigation do
      render "admin/shared/section_tabs", name:, tabs:
    end
  end

  def section_active?(section_key)
    section = admin_sections[section_key]
    return false unless section

    section[:tabs].any? { |tab| current_page? tab[:path] }
  end
end
