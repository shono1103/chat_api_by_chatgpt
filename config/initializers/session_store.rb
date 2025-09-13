Rails.application.config.session_store :cookie_store,
  key: "_your_app_session",
  same_site: :lax,   # 開発なら :lax でOK
  secure: false      # HTTPS を使わないなら false
