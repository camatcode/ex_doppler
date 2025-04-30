defmodule ExDoppler.WebhooksTest do
  use ExUnit.Case
  doctest ExDoppler.Webhooks

  alias ExDoppler.Configs
  alias ExDoppler.Projects
  alias ExDoppler.Webhook
  alias ExDoppler.Webhooks

  test "Webhooks" do
    assert {:ok,  [project | _]} = Projects.list_projects()
    assert {:ok, configs} = Configs.list_configs(project)

    configs_to_apply =
      configs
      |> Enum.filter(fn config -> config.root end)
      |> Enum.take(2)
      |> Enum.map(fn config -> config.name end)

    new_wh_slug = "my-new-webhook"
    Webhooks.delete_webhook(project, %Webhook{id: new_wh_slug})

    assert {:ok, webhook} =
             Webhooks.create_webhook(project, "https://httpbin.org/post",
               name: new_wh_slug,
               enable_configs: configs_to_apply,
               authentication: %{type: :Basic, username: "joe", password: "dirt"}
             )

    assert webhook.name
    assert webhook.authentication.type == "Basic"
    assert webhook.can_manage
    assert webhook.has_secret != nil
    assert webhook.id
    assert webhook.url

    assert {:ok, webhook} == Webhooks.get_webhook(project, webhook.id)

    {:ok, webhook} = Webhooks.disable_webhook(project, webhook)
    refute webhook.enabled

    {:ok, webhook} = Webhooks.enable_webhook(project, webhook)
    assert webhook.enabled

    assert {:ok, webhooks} = Webhooks.list_webhooks(project)
    refute Enum.empty?(webhooks)

    {:ok, _} = Webhooks.delete_webhook(project, webhook)
  end
end
