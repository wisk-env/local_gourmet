// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import Rails from "@rails/ujs"
Rails.start()

import "@hotwired/turbo-rails"
import "controllers"

Turbo.session.drive = false

import jquery from "jquery"
window.$ = jquery
