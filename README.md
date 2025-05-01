<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/camatcode/ex_doppler/refs/heads/master/assets/ex_doppler-logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/camatcode/ex_doppler/refs/heads/master/assets/ex_doppler-logo-light.png">
    <img alt="ex_doppler logo" src="https://raw.githubusercontent.com/camatcode/ex_doppler/refs/heads/master/assets/ex_doppler-logo-light.png" width="320">
  </picture>
</p>

<p align="center">
  Manage and access your Doppler secrets without leaving Elixir
</p>


<p align="center">
  <a href="https://hex.pm/packages/ex_doppler">
    <img alt="Hex Version" src="https://img.shields.io/hexpm/v/ex_doppler.svg">
  </a>

  <a href="https://hexdocs.pm/ex_doppler">
    <img alt="Hex Docs" src="http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat">
  </a>

  <!--
  <a href="https://github.com/camatcode/ex_doppler/actions">
    <img alt="CI Status" src="https://github.com/camatcode/ex_doppler/workflows/ci/badge.svg">
  </a>
  -->
  
  <a href="https://opensource.org/licenses/Apache-2.0">
    <img alt="Apache 2 License" src="https://img.shields.io/hexpm/l/oban">
  </a>

  <a href="https://mastodon.social/@scrum_log">
    <img alt="Mastodon Follow" src="https://img.shields.io/badge/mastodon-%40scrum_log%40mastodon.social-purple?color=6364ff">

  </a>

</p>

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Mapping](#mapping)
- [Not Implemented](#not-implemented)

## Installation

Add `:ex_doppler` to your list of deps in `mix.exs`:

```elixir
{:ex_doppler, "~> 1.0"}
```

Then run `mix deps.get` to install ExDoppler and its dependencies.

## Quick Start

1. [Create a Doppler Token](https://docs.doppler.com/docs/service-tokens#creating-service-tokens)
2. Put your token in your environment (**NEVER** put the token anywhere in your code)
  ```bash
  export HISTIGNORE='export DOPPLER_TOKEN*'
  
  export DOPPLER_TOKEN='dp.st.prd.xxxx'
  ```
3. Use ExDoppler to access your secrets
  ```elixir
      secret_value = ExDoppler.get_secret_raw!("example-project", "dev_personal", "DB_URL")
  ```

4. You're good to go. I really recommend you have a look at [the docs](https://hex.pm/packages/ex_doppler)


## Mapping

| Realm            | Actions Implemented                                                       | ExDoppler Module                   | Notes |
|------------------|---------------------------------------------------------------------------|------------------------------------|-------|
| Activity Logs    | List, Retrieve                                                            | `ExDoppler.ActivityLogs`           |       |
| Auths            | Me, ODIC, Revoke                                                          | `ExDoppler.Auths`                  |       |
| Config Logs      | List, Retrieve, Rollback                                                  | `ExDoppler.ConfigLogs`             |       |
| Configs          | List, Retrieve, Create, Rename, Clone, Lock, Unlock, Delete               | `ExDoppler.Configs`                |       |
| Environments     | List, Retrieve, Create, Update, Delete                                    | `ExDoppler.Environments`           |       |
| Integrations     | List, Retrieve, Create, Update, Get Options, Delete                       | `ExDoppler.Integrations`           |       |
| Invites          | List                                                                      | `ExDoppler.Invites`                |       |
| Project Members  | List, Retrieve                                                            | `ExDoppler.ProjectMembers`         |       |
| Project Roles    | List, Retrieve, Create                                                    | `ExDoppler.ProjectRoles`           |       |
| Projects         | List, Retrieve, Create, Update, Delete, List Project Permissions          | `ExDoppler.Projects`               |       |
| Secret Syncs     | Retrieve, Create, Delete                                                  | `ExDoppler.SecretSyncs`            |       |
| Secrets          | List, Retrieve, Download, List Names, Create, Update, Update Note, Delete | `ExDoppler` or `ExDoppler.Secrets` |       |
| Service Accounts | List                                                                      | `ExDoppler.ServiceAccounts`        |       |
| Service Tokens   | List, Create, Delete                                                      | `ExDoppler.ServiceTokens`          |       |
| Shares           | Plain Text                                                                | `ExDoppler.Shares`                 |       |
| Webhooks         | List, Retrieve, Enable, Disable, Create, Delete                           | `ExDoppler.Webhooks`               |       |
| Workplace Roles  | List, Retrieve                                                            | `ExDoppler.WorkplaceRoles`         |       |
| Workplace Users  | List, Retrieve, Update                                                    | `ExDoppler.WorkplaceUsers`         |       |
| Workplace        | Retrieve, Update                                                          | `ExDoppler.Workplaces`             |       |

## Not Implemented

| Realm : Action                                                                                        | Implemented | Notes                                                  |
|-------------------------------------------------------------------------------------------------------|-------------|--------------------------------------------------------|
| [Project Roles : Create](https://docs.doppler.com/reference/project_roles-create)                     | ⁉️          | Requires a Team tier                                   |
| [Project Roles : Update](https://docs.doppler.com/reference/project_roles-update)                     | ⁉️          | Requires a Team tier                                   |
| [Project Members : Add](https://docs.doppler.com/reference/project_members-add)                       | ⁉️          | Requires a Team tier                                   |
| [Project Members : Update](https://docs.doppler.com/reference/project_members-update)                 | ⁉️          | Requires a Team tier                                   |
| [Project Members : Delete](https://docs.doppler.com/reference/project_members-delete)                 | ⁉️          | Requires a Team tier                                   |
| [Project Roles : Delete](https://docs.doppler.com/reference/project_roles-delete)                     | ⁉️          | Requires a Team tier                                   |
| [Trusted IPs : List](https://docs.doppler.com/reference/configs-list_trusted_ips)                     | ⁉️          | Requires a Team tier                                   |
| [Trusted IPs : Add](https://docs.doppler.com/reference/configs-add_trusted_ip)                        | ⁉️          | Requires a Team tier                                   |
| [Trusted IPs : Delete](https://docs.doppler.com/reference/configs-delete_trusted_ip)                  | ⁉️          | Requires a Team tier                                   |
| [Groups : List](https://docs.doppler.com/reference/groups-list)                                       | ⁉️          | Requires a Team tier                                   |
| [Groups : Create](https://docs.doppler.com/reference/groups-create)                                   | ⁉️          | Requires a Team tier                                   |
| [Groups : Retrieve](https://docs.doppler.com/reference/groups-get)                                    | ⁉️          | Requires a Team tier                                   |
| [Groups : Update](https://docs.doppler.com/reference/groups-update)                                   | ⁉️          | Requires a Team tier                                   |
| [Groups : Delete](https://docs.doppler.com/reference/groups-delete)                                   | ⁉️          | Requires a Team tier                                   |
| [Groups : Add Member](https://docs.doppler.com/reference/groups-add_member)                           | ⁉️          | Requires a Team tier                                   |
| [Groups : Delete Memeber](https://docs.doppler.com/reference/groups-delete_member)                    | ⁉️          | Requires a Team tier                                   |
| [Groups : Retrieve Memeber](https://docs.doppler.com/reference/retrieve-member)                       | ⁉️          | Requires a Team tier                                   |
| [Service Accounts : List](https://docs.doppler.com/reference/service_accounts-list)                   | ⁉️          | Requires a Team tier                                   |
| [Service Accounts : Create](https://docs.doppler.com/reference/service_accounts-create)               | ⁉️          | Requires a Team tier                                   |
| [Service Accounts : Retrieve](https://docs.doppler.com/reference/service_accounts-get)                | ⁉️          | Requires a Team tier                                   |
| [Service Accounts : Update](https://docs.doppler.com/reference/service_accounts-update)               | ⁉️          | Requires a Team tier                                   |
| [Service Accounts : Delete](https://docs.doppler.com/reference/service_accounts-delete)               | ⁉️          | Requires a Team tier                                   |
| [Service Account Tokens : List](https://docs.doppler.com/reference/service_account_tokens-list)       | ⁉️          | Requires a Team tier                                   |
| [Service Account Tokens : Create](https://docs.doppler.com/reference/service_account_tokens-create)   | ⁉️          | Requires a Team tier                                   |
| [Service Account Tokens : Retrieve](https://docs.doppler.com/reference/service_account_tokens-get)    | ⁉️          | Requires a Team tier                                   |
| [Service Account Tokens : Delete](https://docs.doppler.com/reference/service_account_tokens-delete)   | ⁉️          | Requires a Team tier                                   |
| [Webhooks : Update](https://docs.doppler.com/reference/webhooks-update)                               | ⁉️          | It's...complex                                         |
| [Workplace Roles : Create](https://docs.doppler.com/reference/workplace_roles-create)                 | ⁉️          | Requires a Team tier                                   |
| [Workplace Roles : Update](https://docs.doppler.com/reference/workplace_roles-update)                 | ⁉️          | Requires a Team tier                                   |
| [Workplace Roles : Delete](https://docs.doppler.com/reference/workplace_roles-delete)                 | ⁉️          | Requires a Team tier                                   |
| [Configs : Inheritable](https://docs.doppler.com/reference/configs-inheritable)                       | ⁉️          | Requires a Team tier                                   |
| [Configs : Inherits](https://docs.doppler.com/reference/configs-inherits)                             | ⁉️          | Requires a Team tier                                   |
| [Change Request Policies : Create](https://docs.doppler.com/reference/change-request-policies-create) | ⁉️          | Requires a Team tier                                   |
| [Change Request Policies : Retrieve](https://docs.doppler.com/reference/change-request-policies-get)  | ⁉️          | Requires a Team tier                                   |
| [Change Request Policies : Update](https://docs.doppler.com/reference/change-request-policies-update) | ⁉️          | Requires a Team tier                                   |
| [Change Request Policies : Delete](https://docs.doppler.com/reference/change-request-policies-delete) | ⁉️          | Requires a Team tier                                   |
| [Dynamic Secrets : Issue Lease](https://docs.doppler.com/reference/dynamic_secrets-issue_lease)       | ⁉️          | Requires a Team tier                                   |
| [Dynamic Secrets : Revoke](https://docs.doppler.com/reference/dynamic_secrets-revoke_lease)           | ⁉️          | Requires a Team tier                                   |
| [Share : E2E Encrypted](https://docs.doppler.com/reference/share-secret-encrypted)                    | ⁉️          | Spent hours trying to get the link to actually decrypt |

