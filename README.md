<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/camatcode/ex_doppler/refs/heads/master/assets/ex_doppler-logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/camatcode/ex_doppler/refs/heads/master/assets/ex_doppler-logo-light.svg">
    <img alt="ex_doppler logo" src="https://raw.githubusercontent.com/camatcode/ex_doppler/refs/heads/master/assets/ex_doppler-logo-light.svg" width="320">
  </picture>
</p>

<p align="center">
  Manage and access your Doppler secrets without leaving Elixir
</p>


## Implementation Status

### Implemented 

| Realm : Action                                                                                            | Implemented | Notes                        |
|-----------------------------------------------------------------------------------------------------------|-------------|------------------------------|
| [Workplace : Retrieve](https://docs.doppler.com/reference/workplace-get)                                  | ✅           |                              |
| [Workplace Users : List](https://docs.doppler.com/reference/users-list)                                   | ✅           |                              |
| [Workplace Users : Retrieve](https://docs.doppler.com/reference/users-get)                                | ✅           |                              |
| [Workplace Roles : List](https://docs.doppler.com/reference/workplace_roles-list)                         | ✅           |                              |
| [Workplace Roles : Retrieve](https://docs.doppler.com/reference/workplace_roles-get)                      | ✅           |                              |
| [Workplace Roles : List Permissions](https://docs.doppler.com/reference/workplace_roles-list_permissions) | ✅           |                              |
| [Activity Logs : List](https://docs.doppler.com/reference/activity_logs-list)                             | ✅           |                              |
| [Activity Logs : Retrieve](https://docs.doppler.com/reference/activity_logs-retrieve)                     | ✅           |                              |
| [Projects : List](https://docs.doppler.com/reference/projects-list)                                       | ✅           |                              |
| [Projects : Create](https://docs.doppler.com/reference/projects-create)                                   | ✅           |                              |
| [Projects : Retrieve](https://docs.doppler.com/reference/projects-get)                                    | ✅           |                              |
| [Projects : Update](https://docs.doppler.com/reference/projects-update)                                   | ✅           |                              |
| [Projects : Delete](https://docs.doppler.com/reference/projects-update)                                   | ✅           |                              |
| [Project Roles : List](https://docs.doppler.com/reference/project_roles-list)                             | ✅           |                              |
| [Project Roles : Retrieve](https://docs.doppler.com/reference/project_roles-get)                          | ✅           |                              |
| [Project Roles : List Permissions](https://docs.doppler.com/reference/project_roles-list_permissions)     | ✅           |                              |
| [Project Members : List](https://docs.doppler.com/reference/project_members-list)                         | ✅           |                              |
| [Project Members : Retrieve](https://docs.doppler.com/reference/project_members-get)                      | ✅           |                              |
| [Environments : List](https://docs.doppler.com/reference/environments-list)                               | ✅           |                              |
| [Environments : Create](https://docs.doppler.com/reference/environments-create)                           | ✅           |                              |
| [Environments : Retrieve](https://docs.doppler.com/reference/environments-get)                            | ✅           |                              |
| [Environments : Delete](https://docs.doppler.com/reference/environments-delete)                           | ✅           |                              |
| [Environments : Rename](https://docs.doppler.com/reference/environments-rename)                           | ✅           |                              |
| [Configs : List](https://docs.doppler.com/reference/configs-list)                                         | ✅           |                              |
| [Configs : Retrieve](https://docs.doppler.com/reference/configs-get)                                      | ✅           |                              |
| [Configs : Create](https://docs.doppler.com/reference/configs-create)                                     | ✅           |                              |
| [Configs : Update](https://docs.doppler.com/reference/configs-update)                                     | ✅           |                              |
| [Configs : Delete](https://docs.doppler.com/reference/configs-delete)                                     | ✅           |                              |
| [Configs : Clone](https://docs.doppler.com/reference/configs-clone)                                       | ✅           |                              |
| [Configs : Lock](https://docs.doppler.com/reference/configs-lock)                                         | ✅           |                              |
| [Configs : Unlock](https://docs.doppler.com/reference/configs-unlock)                                     | ✅           |                              |
| [Config Logs : List](https://docs.doppler.com/reference/config_logs-list)                                 | ✅           |                              |
| [Config Logs : Retrieve](https://docs.doppler.com/reference/config_logs-get)                              | ✅           |                              |
| [Config Logs : Rollback](https://docs.doppler.com/reference/config_logs-rollback)                         | ✅           |                              |
| [Secrets : List](https://docs.doppler.com/reference/secrets-list)                                         | ✅           |                              |
| [Secrets : Retrieve](https://docs.doppler.com/reference/secrets-get)                                      | ✅           |                              |
| [Secrets : Update](https://docs.doppler.com/reference/secrets-update)                                     | ✅           |                              |
| [Secrets : Download](https://docs.doppler.com/reference/secrets-download)                                 | ✅           |                              |
| [Secrets : List Names](https://docs.doppler.com/reference/secrets-names)                                  | ✅           |                              |
| [Secrets : Delete](https://docs.doppler.com/reference/secrets-delete)                                     | ✅           |                              |
| [Secrets : Update Note](https://docs.doppler.com/reference/secrets-update_note)                           | ✅           |                              |
| [Service Tokens : List](https://docs.doppler.com/reference/service_tokens-list)                           | ✅           |                              |
| [Service Tokens : Create](https://docs.doppler.com/reference/service_tokens-create)                       | ✅           |                              |
| [Service Tokens : Delete](https://docs.doppler.com/reference/service_tokens-delete)                       | ✅           |                              |
| [Integrations : List](https://docs.doppler.com/reference/integrations-list)                               | ✅           |                              |
| [Integrations : Retrieve](https://docs.doppler.com/reference/integrations-get)                            | ✅           |                              |
| [Integrations : Create](https://docs.doppler.com/reference/integrations-create)                           | ✅           | Route has poor documentation |
| [Integrations : Get Options](https://docs.doppler.com/reference/get-options)                              | ✅           |                              |
| [Integrations : Delete](https://docs.doppler.com/reference/integrations-delete)                           | ✅           |                              |
| [Secrets Sync : Create](https://docs.doppler.com/reference/syncs-create)                                  | ✅           |                              |
| [Secrets Sync : Retrieve](https://docs.doppler.com/reference/syncs-get)                                   | ✅           |                              |
| [Secrets Sync : Delete](https://docs.doppler.com/reference/syncs-delete)                                  | ✅           |                              |
| [Invites : List](https://docs.doppler.com/reference/invites-list)                                         | ✅           |                              |
| [Webhooks : List](https://docs.doppler.com/reference/webhooks-list)                                       | ✅           |                              |
| [Webhooks : Retrieve](https://docs.doppler.com/reference/webhooks-get)                                    | ✅           |                              |
| [Webhooks : Add](https://docs.doppler.com/reference/webhooks-add)                                         | ✅           |                              |
| [Webhooks : Delete](https://docs.doppler.com/reference/webhooks-delete)                                   | ✅           |                              |
| [Webhooks : Enable](https://docs.doppler.com/reference/webhooks-enable)                                   | ✅           |                              |
| [Webhooks : Disable](https://docs.doppler.com/reference/webhooks-disable)                                 | ✅           |                              |
| [Auth : Me](https://docs.doppler.com/reference/auth-me)                                                   | ✅           |                              |
| [Share : Plain Text](https://docs.doppler.com/reference/share-secret)                                     | ✅           |                              |



### To Implement

| Realm : Action                                                                                        | Implemented | Notes |
|-------------------------------------------------------------------------------------------------------|-------------|-------|
| [Workplace : Update](https://docs.doppler.com/reference/workplace-update)                             | ❌           |       |
| [Workplace Users : Update](https://docs.doppler.com/reference/users-update)                           | ❌           |       |
| [Integrations : Update](https://docs.doppler.com/reference/integrations-update)                       | ❌           |       |
| [Auth : Revoke](https://docs.doppler.com/reference/auth-revoke)                                       | ❌           |       |
| [Auth : OIDC](https://docs.doppler.com/reference/auth-oidc)                                           | ❌           |       |
| [Share : E2E Encrypted](https://docs.doppler.com/reference/share-secret-encrypted)                    | ❌           |       |

### Requires Investigation

| Realm : Action                                                                                        | Implemented | Notes                |
|-------------------------------------------------------------------------------------------------------|-------------|----------------------|
| [Project Roles : Create](https://docs.doppler.com/reference/project_roles-create)                     | ⁉️          | Requires a Team tier |
| [Project Roles : Update](https://docs.doppler.com/reference/project_roles-update)                     | ⁉️          | Requires a Team tier |
| [Project Members : Add](https://docs.doppler.com/reference/project_members-add)                       | ⁉️          | Requires a Team tier |
| [Project Members : Update](https://docs.doppler.com/reference/project_members-update)                 | ⁉️          | Requires a Team tier |
| [Project Members : Delete](https://docs.doppler.com/reference/project_members-delete)                 | ⁉️          | Requires a Team tier |
| [Project Roles : Delete](https://docs.doppler.com/reference/project_roles-delete)                     | ⁉️          | Requires a Team tier |
| [Trusted IPs : List](https://docs.doppler.com/reference/configs-list_trusted_ips)                     | ⁉️          | Requires a Team tier |
| [Trusted IPs : Add](https://docs.doppler.com/reference/configs-add_trusted_ip)                        | ⁉️          | Requires a Team tier |
| [Trusted IPs : Delete](https://docs.doppler.com/reference/configs-delete_trusted_ip)                  | ⁉️          | Requires a Team tier |
| [Groups : List](https://docs.doppler.com/reference/groups-list)                                       | ⁉️          | Requires a Team tier |
| [Groups : Create](https://docs.doppler.com/reference/groups-create)                                   | ⁉️          | Requires a Team tier |
| [Groups : Retrieve](https://docs.doppler.com/reference/groups-get)                                    | ⁉️          | Requires a Team tier |
| [Groups : Update](https://docs.doppler.com/reference/groups-update)                                   | ⁉️          | Requires a Team tier |
| [Groups : Delete](https://docs.doppler.com/reference/groups-delete)                                   | ⁉️          | Requires a Team tier |
| [Groups : Add Member](https://docs.doppler.com/reference/groups-add_member)                           | ⁉️          | Requires a Team tier |
| [Groups : Delete Memeber](https://docs.doppler.com/reference/groups-delete_member)                    | ⁉️          | Requires a Team tier |
| [Groups : Retrieve Memeber](https://docs.doppler.com/reference/retrieve-member)                       | ⁉️          | Requires a Team tier |
| [Service Accounts : List](https://docs.doppler.com/reference/service_accounts-list)                   | ⁉️          | Requires a Team tier |
| [Service Accounts : Create](https://docs.doppler.com/reference/service_accounts-create)               | ⁉️          | Requires a Team tier |
| [Service Accounts : Retrieve](https://docs.doppler.com/reference/service_accounts-get)                | ⁉️          | Requires a Team tier |
| [Service Accounts : Update](https://docs.doppler.com/reference/service_accounts-update)               | ⁉️          | Requires a Team tier |
| [Service Accounts : Delete](https://docs.doppler.com/reference/service_accounts-delete)               | ⁉️          | Requires a Team tier |
| [Service Account Tokens : List](https://docs.doppler.com/reference/service_account_tokens-list)       | ⁉️          | Requires a Team tier |
| [Service Account Tokens : Create](https://docs.doppler.com/reference/service_account_tokens-create)   | ⁉️          | Requires a Team tier |
| [Service Account Tokens : Retrieve](https://docs.doppler.com/reference/service_account_tokens-get)    | ⁉️          | Requires a Team tier |
| [Service Account Tokens : Delete](https://docs.doppler.com/reference/service_account_tokens-delete)   | ⁉️          | Requires a Team tier |
| [Webhooks : Update](https://docs.doppler.com/reference/webhooks-update)                               | ⁉️          | It's...complex       |
| [Workplace Roles : Create](https://docs.doppler.com/reference/workplace_roles-create)                 | ⁉️          | Requires a Team tier |
| [Workplace Roles : Update](https://docs.doppler.com/reference/workplace_roles-update)                 | ⁉️          | Requires a Team tier |
| [Workplace Roles : Delete](https://docs.doppler.com/reference/workplace_roles-delete)                 | ⁉️          | Requires a Team tier |
| [Configs : Inheritable](https://docs.doppler.com/reference/configs-inheritable)                       | ⁉️          | Requires a Team tier |
| [Configs : Inherits](https://docs.doppler.com/reference/configs-inherits)                             | ⁉️          | Requires a Team tier |
| [Change Request Policies : Create](https://docs.doppler.com/reference/change-request-policies-create) | ⁉️          | Requires a Team tier |
| [Change Request Policies : Retrieve](https://docs.doppler.com/reference/change-request-policies-get)  | ⁉️          | Requires a Team tier |
| [Change Request Policies : Update](https://docs.doppler.com/reference/change-request-policies-update) | ⁉️          | Requires a Team tier |
| [Change Request Policies : Delete](https://docs.doppler.com/reference/change-request-policies-delete) | ⁉️          | Requires a Team tier |
| [Dynamic Secrets : Issue Lease](https://docs.doppler.com/reference/dynamic_secrets-issue_lease)       | ⁉️          | Requires a Team tier |
| [Dynamic Secrets : Revoke](https://docs.doppler.com/reference/dynamic_secrets-revoke_lease)           | ⁉️          | Requires a Team tier |






## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_doppler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_doppler, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ex_doppler>.

