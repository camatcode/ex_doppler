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
