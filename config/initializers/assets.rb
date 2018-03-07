# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w( home.scss event.scss events.scss
                                                  member.scss members.scss team.scss map.js
                                                  jquery.calendars.picker.css jquery.calendars.js
                                                  jquery.calendars.plus.js jquery.plugin.js
                                                  jquery.calendars.picker.js jquery.calendars.lang.js
                                                  jquery.calendars-fr.js jquery.datepick-fr.js
                                                  jquery.calendars.all.js
                                                  webflow.js
                                                  fontawesome-webfont.ttf
                                                  normalize.scss webflow.scss duys-trendy-project.webflow.scss)

Rails.application.config.assets.precompile += %w( pricing.css )
