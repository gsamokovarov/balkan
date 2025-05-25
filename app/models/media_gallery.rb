class MediaGallery < ApplicationRecord
  belongs_to :event
  has_many_attached :photo_highlights

  validates :videos_url, presence: true

  def video_highlights = [video1_url, video2_url, video3_url, video4_url].compact_blank

  def video_embed_url(video_url)
    video_id =
      case video_url
      when /youtube\.com.*[?&]v=([^&]+)/, %r{youtube\.com/embed/([^?]+)}, %r{youtu\.be/([^?]+)}
        Regexp.last_match 1
      end

    "https://www.youtube.com/embed/#{video_id}" if video_id
  end
end
