# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(build/tutorial.ja.js build/tutorial.en.js build/contests.ja.js build/contests.en.js build/admin.ja.js build/admin.en.js)
Rails.application.config.assets.precompile += %w(welcome.css users.css contests.css terms.scss privacy_policies.scss github-markdown.css)
