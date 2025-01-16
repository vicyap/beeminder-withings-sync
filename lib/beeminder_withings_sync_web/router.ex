defmodule BeeminderWithingsSyncWeb.Router do
  use BeeminderWithingsSyncWeb, :router

  import BeeminderWithingsSyncWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BeeminderWithingsSyncWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BeeminderWithingsSyncWeb do
    pipe_through :browser

    get "/", PageController, :home

    get "/beeminder/auth_callback", BeeminderController, :auth_callback

    # https://beeminder-withings-sync.fly.dev/beeminder/auth_callback
    # https://beeminder-withings-sync.fly.dev/beeminder/de_auth_callback
    # https://beeminder-withings-sync.fly.dev/beeminder/auto_fetch_callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", BeeminderWithingsSyncWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:beeminder_withings_sync, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BeeminderWithingsSyncWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", BeeminderWithingsSyncWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{BeeminderWithingsSyncWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/log_in", UserLoginLive, :new
    end
  end

  scope "/", BeeminderWithingsSyncWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BeeminderWithingsSyncWeb.UserAuth, :ensure_authenticated}] do
    end
  end

  scope "/", BeeminderWithingsSyncWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{BeeminderWithingsSyncWeb.UserAuth, :mount_current_user}] do
    end
  end
end
