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
end

defmodule ExDoppler.ProjectRole do
  @moduledoc false
  defstruct [:created_at, :identifier, :is_custom_role, :name, :permissions]
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
end

defmodule ExDoppler.ActivityDiff do
  @moduledoc false
  defstruct [:added, :removed, :updated]
end

defmodule ExDoppler.Project do
  @moduledoc false
  defstruct [:created_at, :description, :id, :name, :slug]
end

defmodule ExDoppler.ProjectMember do
  @moduledoc false
  defstruct [:access_all_environments, :environments, :role, :slug, :type]
end

defmodule ExDoppler.ProjectMemberRole do
  @moduledoc false
  defstruct [:identifier]
end

defmodule ExDoppler.Environment do
  @moduledoc false
  defstruct [:created_at, :id, :initial_fetch_at, :name, :project, :slug]
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
end

defmodule ExDoppler.ConfigLog do
  @moduledoc false
  defstruct [:config, :created_at, :environment, :html, :id, :project, :rollback, :text, :user]
end

defmodule ExDoppler.Secret do
  @moduledoc false
  defstruct [:name, :raw, :computed, :note, :raw_visibility, :computed_visibility]
end

defmodule ExDoppler.Integration do
  @moduledoc false
  defstruct [:slug, :name, :type, :kind, :enabled, :syncs]
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
end
