defmodule ExDoppler.MixProject do
  use Mix.Project

  @source_url "https://github.com/camatcode/ex_doppler"
  @version "1.0.0"

  def project do
    [
      app: :ex_doppler,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      package: package(),
      description: """
      Manage and access your Doppler secrets without leaving Elixir
      """,

      # Docs
      name: "ExDoppler",
      docs: [
        main: "ExDoppler",
        api_reference: false,
        logo: "assets/ex_doppler-logo.png",
        source_ref: "v#{@version}",
        source_url: @source_url,
        extra_section: "GUIDES",
        extras: extras(),
        formatters: ["html"],
        extras: extras(),
        groups_for_modules: groups_for_modules(),
        skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
      ]
    ]
  end

  defp groups_for_modules do
    [
      Service: [
        ExDoppler.ActivityLogs,
        ExDoppler.Auths,
        ExDoppler.ConfigLogs,
        ExDoppler.Configs,
        ExDoppler.Environments,
        ExDoppler.Integrations,
        ExDoppler.Invites,
        ExDoppler.ProjectMembers,
        ExDoppler.ProjectRoles,
        ExDoppler.Projects,
        ExDoppler.SecretSyncs,
        ExDoppler.Secrets,
        ExDoppler.ServiceAccounts,
        ExDoppler.ServiceTokens,
        ExDoppler.Shares,
        ExDoppler.Webhooks,
        ExDoppler.WorkplaceRoles,
        ExDoppler.WorkplaceUsers,
        ExDoppler.Workplaces
      ],
      Models: [
        ExDoppler.ActivityLog,
        ExDoppler.ActivityDiff,
        ExDoppler.Config,
        ExDoppler.ConfigLog,
        ExDoppler.Environment,
        ExDoppler.Integration,
        ExDoppler.Invite,
        ExDoppler.ODICToken,
        ExDoppler.Project,
        ExDoppler.ProjectMember,
        ExDoppler.ProjectMemberRole,
        ExDoppler.ProjectRole,
        ExDoppler.Secret,
        ExDoppler.ServiceAccount,
        ExDoppler.ServiceToken,
        ExDoppler.Share,
        ExDoppler.Sync,
        ExDoppler.TokenInfo,
        ExDoppler.User,
        ExDoppler.Webhook,
        ExDoppler.WebhookAuth,
        ExDoppler.Workplace,
        ExDoppler.WorkplaceRole,
        ExDoppler.WorkplaceUser
      ],
      Util: [
        ExDoppler.Doc,
        ExDoppler.Requester
      ]
    ]
  end

  def package do
    [
      maintainers: ["Cam Cook"],
      licenses: ["Apache-2.0"],
      files: ~w(lib .formatter.exs mix.exs README* CHANGELOG* LICENSE*),
      links: %{
        Website: @source_url,
        Changelog: "#{@source_url}/blob/main/CHANGELOG.md",
        GitHub: @source_url
      }
    ]
  end

  def extras do
    [
      "README.md"
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
      {:ex_doc, "~> 0.37", only: :dev, runtime: false},
      {:ex_license, "~> 0.1.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.8.0", only: :test},
      {:faker, "~> 0.18.0", only: :test},
      {:req, "~> 0.5.10"},
      {:date_time_parser, "~> 1.2.0"},
      {:proper_case, "~> 1.3"}
    ]
  end
end
