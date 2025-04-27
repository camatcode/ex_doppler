defmodule ExDoppler.WebhooksTest do
  use ExUnit.Case
  doctest ExDoppler.Webhooks

  alias ExDoppler.Projects
  alias ExDoppler.Webhooks

  test "Webhooks" do
    assert {:ok, %{projects: [project | _]}} = Projects.list_projects()
    assert {:ok, _webhooks} = Webhooks.list_webhooks(project)
  end
end
