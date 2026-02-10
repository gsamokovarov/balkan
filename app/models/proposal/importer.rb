require "csv"

module Proposal::Importer
  extend self

  COLUMNS = {
    "Your name" => :name,
    "Email" => :email,
    "Where are you from?" => :location,
    "Your company?" => :company,
    "Github profile" => :github_url,
    "Twitter profile" => :social_url,
    "Title" => :title,
    "Description" => :description,
    "Anything else you want to share with us" => :notes,
  }

  def import(event, csv)
    rows = CSV.parse csv.force_encoding("UTF-8"), headers: true

    rows.each do |row|
      attributes = COLUMNS.each_with_object({}) do |(header, field), hash|
        hash[field] = row[header].presence || "Not provided"
      end

      event.proposals.create! attributes
    end

    rows.size
  end
end
