defmodule MunchWeb.Router do
  use MunchWeb, :router

  import MunchWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MunchWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MunchWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:munch, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MunchWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", MunchWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{MunchWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log_in", UserLive.Login, :new
      live "/users/reset_password", UserLive.ForgotPassword, :new
      live "/users/reset_password/:token", UserLive.ResetPassword, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", MunchWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{MunchWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm_email/:token", UserLive.Settings, :confirm_email
      live "/users/edit", UserLive.ProfileForm, :edit

      live "/restaurants/new", RestaurantLive.Import, :new
      live "/restaurants/new-by-id", RestaurantLive.ImportManual, :new
      live "/restaurant/:id/edit", RestaurantLive.Edit, :edit

      live "/lists/new", ListLive.Form, :new
      live "/list/:id/edit", ListLive.Form, :edit
    end
  end

  scope "/", MunchWeb do
    pipe_through [:browser]

    get "/", PageController, :home

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{MunchWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserLive.Confirmation, :edit
      live "/users/confirm", UserLive.ConfirmationInstructions, :new

      live "/restaurants", RestaurantLive.Index, :index
      live "/restaurant/:id", RestaurantLive.Show, :show

      live "/lists", ListLive.Index, :index
      live "/list/:id", ListLive.Show, :show

      live "/user/:id", UserLive.Profile, :show
    end
  end
end
