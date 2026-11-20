config = {
  server: "168.119.247.9",
  app: "balkan",
  repo: "gsamokovarov/balkan",
  env_file: "/var/lib/balkan/env_file",
  volumes: { "/var/lib/balkan/db" => "/rails/db/production", "/var/lib/balkan/storage" => "/rails/storage" },
  port: 3000,
  host_ports: [3001, 3002],
  health: "/healthz",
}

Hamal.deploy config do
  command :deploy, "Deploy the app to the server" do
    build
    run "/rails/bin/rails db:migrate"

    rollout do |port|
      nginx.render "/etc/nginx/balkan.conf.template", ACTIVE_RAILS_PORT: port
      nginx.reload
    end
  end

  command :console, "Run Rails console in the deployed image" do
    run "/rails/bin/rails console", tty: true
  end

  command :backup, "Download the SQLite database", aliases: [:dump] do
    download "/var/lib/balkan/db/data.sqlite3", "data.sqlite3"
  end
end
