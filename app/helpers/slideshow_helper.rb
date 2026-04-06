module SlideshowHelper
  def render_slideshow(slideshow, day:)
    event = slideshow.event

    event_dates =
      if event.start_date.month == event.end_date.month
        "#{event.start_date.strftime '%B'} #{event.start_date.day}-#{event.end_date.day}, #{event.end_date.year}"
      else
        "#{event.start_date.strftime '%B %d'} - #{event.end_date.strftime '%B %d, %Y'}"
      end

    variables = {
      "day" => day,
      "event_title" => event.title,
      "event_subtitle" => event.subtitle,
      "event_host" => event.host,
      "event_dates" => event_dates,
      "ticket_count" => event.tickets.count,
    }

    variables["event_logo"] = render("slideshow/event_logo", event:) if event.logo.attached?
    if event.community_partners.any?
      variables["community_partners"] = render("slideshow/community_partners", partners: event.community_partners)
    end
    variables["sponsors"] = render("slideshow/sponsors", sponsorships: event.sponsors) if event.sponsorships.any?
    variables["qr_code"] = render("slideshow/qr_code", event:)

    event.lineup_members.where(role: "Master of Ceremonies").each.with_index(1) do |mc, i|
      variables["mc_#{i}"] = render "slideshow/mc", lineup_member: mc
    end

    event.community_partners.each do |partner|
      key = "partner_#{partner.name.parameterize separator: '_'}"
      variables[key] = render "slideshow/partner", partner:
    end

    if event.schedule
      fiscal_sponsors = (event.sponsorships.filter(&:fiscal?).presence || [nil]).cycle
      talks, breaks = event.schedule.slots_for_day(day).partition { it.lineup_member&.talk }

      talks.each.with_index 1 do |slot, i|
        variables["talk_#{i}"] = render "slideshow/talk", slot:, sponsorship: fiscal_sponsors.next
      end

      breaks.each.with_index 1 do |slot, i|
        variables["break_#{i}"] = render "slideshow/break", slot:
      end
    end

    template = Liquid::Template.parse slideshow.content
    rendered = template.render variables, strict_variables: false
    rendered.split("---").map(&:strip).reject(&:blank?)
  end
end
