FactoryBot.define do
  factory :sponsor do
    name { "Sponsor #{rand 1000}" }
    description { "Description for sponsor" }
    url { "https://example.com" }

    trait :with_logo do
      after :build do |sponsor|
        file_path = Rails.root.join "spec", "fixtures", "files", "logo.png"
        if File.exist? file_path
          sponsor.logo.attach(
            io: File.open(file_path),
            filename: "logo.png",
            content_type: "image/png",
          )
        end
      end
    end
  end
end
