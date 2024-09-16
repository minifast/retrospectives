// Import and register all your controllers from the importmap under controllers/*

import { application } from "hotwire/jasmine/controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("hotwire/jasmine/controllers", application)
