# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "reveal.js", to: "https://ga.jspm.io/npm:reveal.js@5.0.5/dist/reveal.esm.js"
pin_all_from "app/javascript/controllers", under: "controllers"
