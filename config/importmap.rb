# Pin npm packages by running ./bin/importmap

pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin 'application'
pin 'canvas-confetti', to: 'https://ga.jspm.io/npm:canvas-confetti@1.5.1/dist/confetti.module.mjs'
pin 'hotkeys-js', to: 'https://ga.jspm.io/npm:hotkeys-js@3.9.4/dist/hotkeys.esm.js'
pin 'stimulus-dropdown', to: 'https://ga.jspm.io/npm:stimulus-dropdown@2.0.0/dist/stimulus-dropdown.es.js'
pin 'stimulus-clipboard', to: 'https://ga.jspm.io/npm:stimulus-clipboard@3.2.0/dist/stimulus-clipboard.es.js'
pin 'stimulus-notification', to: 'https://ga.jspm.io/npm:stimulus-notification@2.0.0/dist/stimulus-notification.es.js'
pin 'stimulus-rails-nested-form', to: 'https://ga.jspm.io/npm:stimulus-rails-nested-form@4.0.0/dist/stimulus-rails-nested-form.es.js'
pin 'stimulus-reveal-controller', to: 'https://ga.jspm.io/npm:stimulus-reveal-controller@4.0.0/dist/stimulus-reveal-controller.es.js'
pin 'stimulus-timeago', to: 'https://ga.jspm.io/npm:stimulus-timeago@4.0.0/dist/stimulus-timeago.es.js'
pin 'stimulus-use', to: 'https://ga.jspm.io/npm:stimulus-use@0.50.0/dist/index.js'
pin 'tailwindcss-stimulus-components', to: 'https://ga.jspm.io/npm:tailwindcss-stimulus-components@3.0.4/dist/tailwindcss-stimulus-components.modern.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'spec/javascript', to: 'spec/javascript'

pin_all_from 'app/javascript/hotwire/jasmine/controllers', under: 'hotwire/jasmine/controllers'
pin 'hotwire/jasmine/application', preload: true
pin 'jasmine-core/lib/jasmine-core/jasmine.js', to: 'https://ga.jspm.io/npm:jasmine-core@4.3.0/lib/jasmine-core/jasmine.js'
pin 'process', to: 'https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/process-production.js'
pin '@rails/actioncable', to: 'https://ga.jspm.io/npm:@rails/actioncable@7.0.3-1/app/assets/javascripts/actioncable.esm.js'
