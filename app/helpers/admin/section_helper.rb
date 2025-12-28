module Admin::SectionHelper
  def admin_sections
    @admin_sections ||= {
      # Event-scoped sections
      ticketing: {
        name: "Ticketing",
        tabs: [
          { name: "Ticket types", path: admin_event_ticket_types_path(Current.event) },
          { name: "Tickets", path: admin_event_tickets_path(Current.event) },
          { name: "Orders", path: admin_current_orders_path },
        ],
      },

      program: {
        name: "Program",
        tabs: [
          { name: "Schedule", path: admin_event_schedule_path(Current.event) },
          { name: "Lineup members", path: admin_event_lineup_members_path(Current.event) },
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
          { name: "Subscribers", path: admin_event_subscribers_path(Current.event) },
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

      # Global sections
      system: {
        name: "System",
        tabs: [
          { name: "Orders", path: admin_orders_path },
          { name: "Invoice sequences", path: admin_invoice_sequences_path },
          { name: "Users", path: admin_users_path },
        ],
      },
    }
  end

  def section_navigation(section_key)
    admin_sections.fetch(section_key) => { name:, tabs: }

    render "admin/shared/section_tabs", name:, tabs:
  end
end
