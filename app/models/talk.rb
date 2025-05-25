class Talk < ApplicationRecord
  has_and_belongs_to_many :speakers
  has_one_attached :ogp_image

  validates :name, presence: true

  def speaker_names = speakers.map(&:name).to_sentence

  def video_embed_url
    video_id =
      case video_url
      when /youtube\.com.*[?&]v=([^&]+)/, %r{youtube\.com/embed/([^?]+)}, %r{youtu\.be/([^?]+)}
        Regexp.last_match 1
      end

    "https://www.youtube.com/embed/#{video_id}" if video_id
  end
end
