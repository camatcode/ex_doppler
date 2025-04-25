defmodule ExDoppler.Workplace do
  defstruct [:billing_email, :name, :security_email, :id]
end

defmodule ExDoppler.WorkplaceUser do
  defstruct [:access, :created_at, :id, :user]
end

defmodule ExDoppler.User do
  defstruct [:email, :name, :profile_image_url, :username]
end
