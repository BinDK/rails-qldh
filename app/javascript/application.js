// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"

import "admin-lte"
import * as bootstrap from "bootstrap"

window.toastr = require('toastr')

import  "@fortawesome/fontawesome-free/js/all"


import Popper from "popper.js"

window.popper = Popper
//
