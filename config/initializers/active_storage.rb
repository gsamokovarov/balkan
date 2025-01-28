# Allow SVG to be served as non-binary content. I upload the SVG's myself so I know they are safe.
Rails.configuration.active_storage.content_types_to_serve_as_binary -= ["image/svg+xml"]
