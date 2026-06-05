namespace :media_galleries do
  # One-time data migration: the gallery was consolidated onto a single
  # `photos` attachment, so rename the existing `photo_highlights` attachments.
  # Idempotent — re-running it simply finds nothing left to rename. Remove this
  # task once it has been run in production.
  desc "Rename MediaGallery photo_highlights attachments to photos (one-time)"
  task rename_photo_highlights_to_photos: :environment do
    count = ActiveStorage::Attachment
      .where(record_type: "MediaGallery", name: "photo_highlights")
      .update_all(name: "photos")

    puts "Renamed #{count} photo_highlights attachment(s) to photos."
  end
end
