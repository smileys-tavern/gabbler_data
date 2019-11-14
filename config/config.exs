use Mix.Config

config :gabbler_data, GabblerData.Repo,
  database: "gabbler",
  username: "gabbler",
  password: "gabbler",
  hostname: "localhost"

config :gabbler_data, 
  ecto_repos: [GabblerData.Repo]