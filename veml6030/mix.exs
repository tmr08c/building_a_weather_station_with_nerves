defmodule Veml6030.MixProject do
  use Mix.Project

  def project do
    [
      app: :veml6030,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # 2.0 introduces the idea of backends. It ships with a backend for Linux,
      # which does not seem to want to work on macOS. 1.0 doesn't complain.
      {:circuits_i2c, "~> 1.0"}
    ]
  end
end
