# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Requester do
  @moduledoc false

  require Logger

  @base_url "https://api.doppler.com/"

  def request(method, path, opts \\ []) do
    qparams = opts[:qparams]
    is_retry = opts[:is_retry]

    opts =
      opts
      |> Keyword.delete(:qparams)
      |> Keyword.delete(:is_retry)
      |> Keyword.put(:headers, [auth_header()])

    path =
      @base_url
      |> Path.join(path)
      |> handle_qparams(qparams)

    method
    |> make_request(path, opts)
    |> case do
      {:ok, %Req.Response{status: 200, body: _body, headers: _headers}} = resp ->
        resp

      {:ok, %Req.Response{status: 204, body: _body, headers: _headers}} = resp ->
        resp

      {:ok, %Req.Response{status: 429, headers: %{"retry-after" => [seconds_str]}}} ->
        if is_retry do
          {:error, "Rate limit exceeded"}
        else
          seconds = String.to_integer(seconds_str)
          milliseconds = (seconds + 1) * 1000

          Logger.debug(
            "Hit a rate limit, waiting #{milliseconds} milliseconds and retrying. See: https://docs.doppler.com/docs/platform-limits#plan-limits"
          )

          :timer.sleep(milliseconds)
          new_opts = Keyword.put(opts, :is_retry, true)
          request(method, path, new_opts)
        end

      other ->
        {:error, other}
    end
  end

  def get(path, opts \\ []), do: request(:get, path, opts)

  def post(path, opts \\ []), do: request(:post, path, opts)

  def put(path, opts \\ []), do: request(:put, path, opts)

  def patch(path, opts \\ []), do: request(:patch, path, opts)

  def delete(path, opts \\ []), do: request(:delete, path, opts)

  defp auth_header do
    auth_token = Application.get_env(:ex_doppler, :token) || System.get_env("DOPPLER_TOKEN")
    {"authorization", "Bearer #{auth_token}"}
  end

  defp handle_qparams(url, nil), do: url

  defp handle_qparams(url, qparams) do
    qparams =
      qparams
      |> Enum.filter(fn {_k, v} -> v end)
      |> URI.encode_query()

    url
    |> URI.parse()
    |> Map.put(:query, qparams)
    |> URI.to_string()
  end

  def make_request(:get, path, opts), do: Req.get(path, opts)
  def make_request(:post, path, opts), do: Req.post(path, opts)
  def make_request(:put, path, opts), do: Req.put(path, opts)
  def make_request(:delete, path, opts), do: Req.delete(path, opts)
  def make_request(:patch, path, opts), do: Req.patch(path, opts)
end
