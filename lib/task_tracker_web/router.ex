defmodule TaskTrackerWeb.Router do
  use TaskTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TaskTrackerWeb.Plugs.FetchSession
  end

  pipeline :ajax do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug TaskTrackerWeb.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaskTrackerWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    resources "/tasks", TaskController
    get "/tasks/complete/:id", TaskController, :show_completion_form
    put "/tasks/complete/:id", TaskController, :show_completion_form
    put "/tasks/complete/do/:id", TaskController, :complete
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
    resources "/time_blocks", TimeBlockController, except: [:new, :edit]
  end

  scope "/ajax", TaskTrackerWeb do
    pipe_through :ajax
    resources "/time_blocks", TimeBlockController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskTrackerWeb do
  #   pipe_through :api
  # end
end
