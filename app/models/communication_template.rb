class CommunicationTemplate < ApplicationRecord
  has_many :communications

  validates :name, presence: true, uniqueness: true
  validates :subject_template, presence: true, liquid: true
  validates :content_template, presence: true, liquid: true

  def preview(context = {})
    sample_context = {
      "email" => "sample@example.com",
      "event_name" => "Sample Conference 2026",
      "event_start_date" => "2026-05-15",
      "event_end_date" => "2026-05-16",
      "year" => "2026"
    }.merge(context.stringify_keys)

    {
      subject: Liquid::Template.parse(subject_template).render(sample_context),
      body: Liquid::Template.parse(content_template).render(sample_context)
    }
  end
end
