# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Doc do
  @moduledoc false

  def maintainer_github,
    do: "[Github: camatcode](https://github.com/camatcode/){:target=\"_blank\"}"

  def maintainer_fediverse,
    do:
      "[Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target=\"_blank\"}"

  def contact_maintainer, do: "Contact the maintainer (he's happy to help!)"

  def resources_block(doppler_doc, doppler_api_doc) do
    "### Resources
  * #{see_doppler_doc("https://docs.doppler.com/docs/#{doppler_doc}")}
  * #{see_api_docs("https://docs.doppler.com/reference/#{doppler_api_doc}")}
  * #{contact_maintainer()}
    * #{maintainer_github()}
    * #{maintainer_fediverse()}
    "
  end

  def see_api_docs(url) do
    see_link("Doppler API docs", url)
  end

  def see_doppler_doc(url) do
    see_link("Doppler docs", url)
  end

  def see_link(title, url) do
    "See: [#{title}](#{url}){:target=\"_blank\"}"
  end
end
