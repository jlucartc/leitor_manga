# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "vue", to: "https://unpkg.com/vue@3/dist/vue.esm-browser.js", preload: true
pin_all_from "app/javascript/vue-app", under: "vue-app", preload: true
