# ExDoppler

## Implementation Status

| Realm : Action                     | Implemented | Notes                                                     |
|------------------------------------|-------------|-----------------------------------------------------------|
| Workplace : Retrieve               | ✅           |                                                           |
| Workplace : Update                 | ❌           |                                                           |
| Workplace Users : List             | ✅           |                                                           |
| Workplace Users : Retrieve         | ✅           |                                                           |
| Workplace Users : Update           | ❌           |                                                           |
| Workplace Roles : List             | ✅           |                                                           |
| Workplace Roles : Retrieve         | ✅           |                                                           |
| Workplace Roles : Create           | ❌           |                                                           |
| Workplace Roles : Update           | ❌           |                                                           |
| Workplace Roles : Delete           | ❌           |                                                           |
| Workplace Roles : List Permissions | ✅           |                                                           |
| Activity Logs : List               | ✅           |                                                           |
| Activity Logs : Retrieve           | ✅           |                                                           |
| Projects : List                    | ✅           |                                                           |
| Projects : Create                  | ❌           |                                                           |
| Projects : Retrieve                | ✅           |                                                           |
| Projects : Update                  | ❌           |                                                           |
| Projects : Delete                  | ❌           |                                                           |
| Project Roles : List               | ✅           |                                                           |
| Project Roles : Retrieve           | ✅           |                                                           |
| Project Roles : Create             | ❌           |                                                           |
| Project Roles : Update             | ❌           |                                                           |
| Project Roles : Delete             | ❌           |                                                           |
| Project Roles : List Permissions   | ✅           |                                                           |
| Project Members : List             | ✅           |                                                           |
| Project Members : Retrieve         | ✅           |                                                           |
| Project Members : Add              | ❌           |                                                           |
| Project Members : Update           | ❌           |                                                           |
| Project Members : Delete           | ❌           |                                                           |
| Environments : List                | ✅           |                                                           |
| Environments : Retrieve            | ✅           |                                                           |
| Environments : Create              | ❌           |                                                           |
| Environments : Delete              | ❌           |                                                           |
| Environments : Rename              | ❌           |                                                           |
| Configs : List                     | ✅           |                                                           |
| Configs : Create                   | ❌           |                                                           |
| Configs : Retrieve                 | ✅           |                                                           |
| Configs : Update                   | ❌           |                                                           |
| Configs : Delete                   | ❌           |                                                           |
| Configs : Clone                    | ❌           |                                                           |
| Configs : Lock                     | ❌           |                                                           |
| Configs : Unlock                   | ❌           |                                                           |
| Configs : Inheritable              | ❌           |                                                           |
| Configs : Inherits                 | ❌           |                                                           |
| Config Logs : List                 | ✅           |                                                           |
| Config Logs : Retrieve             | ✅           |                                                           |
| Config Logs : Rollback             | ❌           |                                                           |
| Trusted IPs : List                 | ⁉️          | Account doesn't have access to it                         |
| Trusted IPs : Add                  | ⁉️          | Account doesn't have access to it                         |
| Trusted IPs : Delete               | ⁉️          | Account doesn't have access to it                         |
| Secrets : List                     | ✅           |                                                           |
| Secrets : Retrieve                 | ✅           |                                                           |
| Secrets : Delete                   | ❌           |                                                           |
| Secrets : Update                   | ❌           |                                                           |
| Secrets : Download                 | ✅           |                                                           |
| Secrets : List Names               | ✅           |                                                           |
| Secrets : Update Note              | ❌           |                                                           |
| Integrations : List                | ⁉️          | Technically implemented - will have to come back to test |
| Integrations : Create              | ❌           |                                                           |
| Integrations : Retrieve            | ❌           |                                                           |
| Integrations : Get Options         | ❌           |                                                           |
| Integrations : Update              | ❌           |                                                           |
| Integrations : Delete              | ❌           |                                                           |
| Secrets Sync : Create              | ❌           |                                                           |
| Secrets Sync : Retrieve            | ❌           |                                                           |
| Secrets Sync : Delete              | ❌           |                                                           |
| Dynamic Secrets : Issue Lease      | ❌           |                                                           |
| Dynamic Secrets : Revoke           | ❌           |                                                           |
| Service Tokens : List              | ❌           |                                                           |
| Service Tokens : Create            | ❌           |                                                           |
| Service Tokens : Delete            | ❌           |                                                           |
| Invites : List                     | ❌           |                                                           |
| Groups : List                      | ❌           |                                                           |
| Groups : Create                    | ❌           |                                                           |
| Groups : Retrieve                  | ❌           |                                                           |
| Groups : Update                    | ❌           |                                                           |
| Groups : Delete                    | ❌           |                                                           |
| Groups : Add Member                | ❌           |                                                           |
| Groups : Delete Memeber            | ❌           |                                                           |
| Groups : Retrieve Memeber          | ❌           |                                                           |
| Service Accounts : List            | ❌           |                                                           |
| Service Accounts : Create          | ❌           |                                                           |
| Service Accounts : Retrieve        | ❌           |                                                           |
| Service Accounts : Update          | ❌           |                                                           |
| Service Accounts : Delete          | ❌           |                                                           |
| Service Account Tokens : List      | ❌           |                                                           |
| Service Account Tokens : Create    | ❌           |                                                           |
| Service Account Tokens : Retrieve  | ❌           |                                                           |
| Service Account Tokens : Delete    | ❌           |                                                           |
| Webhooks : List                    | ❌           |                                                           |
| Webhooks : Retrieve                | ❌           |                                                           |
| Webhooks : Add                     | ❌           |                                                           |
| Webhooks : Update                  | ❌           |                                                           |
| Webhooks : Delete                  | ❌           |                                                           |
| Webhooks : Enable                  | ❌           |                                                           |
| Webhooks : Disable                 | ❌           |                                                           |
| Change Request Policies : Create   | ❌           |                                                           |
| Change Request Policies : Retrieve | ❌           |                                                           |
| Change Request Policies : Update   | ❌           |                                                           |
| Change Request Policies : Delete   | ❌           |                                                           |
| Auth : Revoke                      | ❌           |                                                           |
| Auth : OIDC                        | ❌           |                                                           |
| Auth : Me                          | ❌           |                                                           |
| Share : Plain Text                 | ❌           |                                                           |
| Share : E2E Encrypted              | ❌           |                                                           |
| Audit API : Workplace              | ❌           |                                                           |
| Audit API : Workplace Users        | ❌           |                                                           |
| Audit API : Workplace User         | ❌           |                                                           |


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

