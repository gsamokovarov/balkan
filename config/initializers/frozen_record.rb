FrozenRecord::Base.base_path = Rails.root.join('data').to_s
FrozenRecord::Base.auto_reloading = true if Rails.env.development?
