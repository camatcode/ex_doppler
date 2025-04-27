defmodule ExDoppler.Workplace do
  @moduledoc false
  defstruct [:billing_email, :name, :security_email, :id]
end

defmodule ExDoppler.WorkplaceUser do
  @moduledoc false
  defstruct [:access, :created_at, :id, :user]
end

defmodule ExDoppler.User do
  @moduledoc false
  defstruct [:email, :name, :profile_image_url, :username]
end

defmodule ExDoppler.WorkplaceRole do
  @moduledoc false
  defstruct [:created_at, :identifier, :is_custom_role, :is_inline_role, :name, :permissions]

  def all_permissions(),
    do: [
      :all_enclave_projects_admin,
      :all_enclave_projects,
      :billing_manage,
      :billing,
      :create_enclave_project,
      :custom_roles_manage,
      :ekm,
      :enclave_secrets_referencing,
      :logs_audit,
      :logs,
      :service_account_api_tokens_manage,
      :service_account_api_tokens,
      :service_accounts_manage,
      :service_accounts,
      :settings_manage,
      :settings,
      :team_manage,
      :team,
      :verified_domains_manage,
      :verified_domains,
      :workplace_default_environments_manage,
      :workplace_default_environments_read,
      :workplace_integrations_list,
      :workplace_integrations_manage,
      :workplace_integrations_read
    ]
end

defmodule ExDoppler.DefaultWorkplaceRole do
  @moduledoc false
  defstruct [:identifier]
end

defmodule ExDoppler.ProjectRole do
  @moduledoc false
  defstruct [:created_at, :identifier, :is_custom_role, :name, :permissions]

  def build_project_role(role) do
    fields =
      role
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.ProjectRole, fields)
  end
end

defmodule ExDoppler.ActivityLog do
  @moduledoc false
  defstruct [
    :created_at,
    :diff,
    :enclave_config,
    :enclave_environment,
    :enclave_project,
    :html,
    :id,
    :text,
    :user
  ]

  def build_activity_log(activity_log) do
    fields =
      activity_log
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ActivityLog, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:user, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.User, val)
  end

  defp serialize(:diff, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.ActivityDiff, val)
  end

  defp serialize(_, val), do: val
end

defmodule ExDoppler.ActivityDiff do
  @moduledoc false
  defstruct [:added, :removed, :updated]
end

defmodule ExDoppler.Project do
  @moduledoc false
  defstruct [:created_at, :description, :id, :name, :slug]

  def build_project(project) do
    fields =
      project
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.Project, fields)
  end
end

defmodule ExDoppler.ProjectMember do
  @moduledoc false
  defstruct [:access_all_environments, :environments, :role, :slug, :type]

  def build_project_member(member) do
    fields =
      member
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ProjectMember, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:role, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.ProjectMemberRole, val)
  end

  defp serialize(_, val), do: val
end

defmodule ExDoppler.ProjectMemberRole do
  @moduledoc false
  defstruct [:identifier]
end

defmodule ExDoppler.Environment do
  @moduledoc false
  defstruct [:created_at, :id, :initial_fetch_at, :name, :project, :slug]

  def build_environment(env) do
    fields =
      env
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.Environment, fields)
  end
end

defmodule ExDoppler.Config do
  @moduledoc false

  defstruct [
    :created_at,
    :environment,
    :inheritable,
    :inheriting,
    :inherits,
    :initial_fetch_at,
    :last_fetch_at,
    :locked,
    :name,
    :project,
    :root,
    :slug
  ]

  def build_config(config) do
    fields =
      config
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.Config, fields)
  end
end

defmodule ExDoppler.ConfigLog do
  @moduledoc false
  defstruct [:config, :created_at, :environment, :html, :id, :project, :rollback, :text, :user]

  def build_config_log(log) do
    fields =
      log
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ConfigLog, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:user, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.User, val)
  end

  defp serialize(_, val), do: val
end

defmodule ExDoppler.Secret do
  @moduledoc false
  defstruct [:name, :raw, :computed, :note, :raw_visibility, :computed_visibility]

  def build_secret({name, map}) do
    fields =
      Map.put(map, "name", name)
      |> Enum.map(fn {key, val} ->
        # Doppler foolishly uses camelCase for this
        key = ProperCase.snake_case(key) |> String.to_atom()
        {key, val}
      end)

    struct(ExDoppler.Secret, fields)
  end
end

defmodule ExDoppler.Integration do
  @moduledoc false
  defstruct [:slug, :name, :type, :kind, :enabled, :syncs]

  def build_integration(integration) do
    fields =
      integration
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Integration, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:syncs, val) do
    val =
      val
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        key = if key == :lastSyncedAt, do: :last_synced_at, else: key
        {key, val}
      end)

    struct(ExDoppler.Sync, val)
  end

  defp serialize(_, val), do: val
end

defmodule ExDoppler.Sync do
  @moduledoc false
  defstruct [:slug, :enabled, :last_synced_at, :project, :config, :integration]
end

defmodule ExDoppler.ServiceToken do
  @moduledoc false
  defstruct [:name, :slug, :created_at, :config, :environment, :project, :expires_at]
end

defmodule ExDoppler.Invite do
  @moduledoc false
  defstruct [:slug, :email, :created_at, :workplace_role]

  def build_invite(invite) do
    fields =
      invite
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Invite, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:workplace_role, val) do
    val =
      val
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.WorkplaceRole, val)
  end

  defp serialize(_, val), do: val
end

defmodule ExDoppler.ServiceAccount do
  @moduledoc false
  defstruct [:name, :slug, :created_at, :workplace_role]
end

defmodule ExDoppler.TokenInfo do
  @moduledoc false
  defstruct [:slug, :name, :created_at, :last_seen_at, :type, :token_preview, :workplace]

  def build_token_info(token_info) do
    fields =
      token_info
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.TokenInfo, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:workplace, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.Workplace, val)
  end

  defp serialize(_, val), do: val
end
