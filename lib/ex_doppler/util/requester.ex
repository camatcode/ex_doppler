defmodule ExDoppler.Util.Requester do
  @moduledoc false

  require Logger

  def get(path, opts \\ []) do
    qparams = opts[:qparams]

    opts =
      Keyword.delete(opts, :qparams)
      |> Keyword.put(:headers, [auth_header()])

    base_url()
    |> Path.join(path)
    |> handle_qparams(qparams)
    |> Req.get(opts)
    |> case do
      {:ok, %Req.Response{status: 200, body: _body, headers: _headers}} = resp ->
        resp

      {:ok, %Req.Response{status: 429, headers: %{"retry-after" => [seconds_str]}}} ->
        if opts[:is_retry] do
          {:err, "Rate limit exceeded"}
        else
          seconds = String.to_integer(seconds_str)
          milliseconds = (seconds + 1) * 1000
          Logger.debug("Hit a rate limit, waiting #{milliseconds} milliseconds and retrying")
          :timer.sleep(milliseconds)
          new_opts = Keyword.merge(opts, is_retry: true)
          get(path, new_opts)
        end

      other ->
        {:err, other}
    end
  end

  def post(path, opts \\ []) do
    qparams = opts[:qparams]

    opts =
      Keyword.delete(opts, :qparams)
      |> Keyword.put(:headers, [auth_header()])

    base_url()
    |> Path.join(path)
    |> handle_qparams(qparams)
    |> Req.post(opts)
    |> case do
      {:ok, %Req.Response{status: 200, body: _body, headers: _headers}} = resp ->
        resp

      {:ok, %Req.Response{status: 429, headers: %{"retry-after" => [seconds_str]}}} ->
        if opts[:is_retry] do
          {:err, "Rate limit exceeded"}
        else
          seconds = String.to_integer(seconds_str)
          milliseconds = (seconds + 1) * 1000
          Logger.debug("Hit a rate limit, waiting #{milliseconds} milliseconds and retrying")
          :timer.sleep(milliseconds)
          new_opts = Keyword.merge(opts, is_retry: true)
          get(path, new_opts)
        end

      other ->
        {:err, other}
    end
  end

  def put(path, opts \\ []) do
    qparams = opts[:qparams]

    opts =
      Keyword.delete(opts, :qparams)
      |> Keyword.put(:headers, [auth_header()])

    base_url()
    |> Path.join(path)
    |> handle_qparams(qparams)
    |> Req.put(opts)
    |> case do
      {:ok, %Req.Response{status: 200, body: _body, headers: _headers}} = resp ->
        resp

      {:ok, %Req.Response{status: 429, headers: %{"retry-after" => [seconds_str]}}} ->
        if opts[:is_retry] do
          {:err, "Rate limit exceeded"}
        else
          seconds = String.to_integer(seconds_str)
          milliseconds = (seconds + 1) * 1000
          Logger.debug("Hit a rate limit, waiting #{milliseconds} milliseconds and retrying")
          :timer.sleep(milliseconds)
          new_opts = Keyword.merge(opts, is_retry: true)
          get(path, new_opts)
        end

      other ->
        {:err, other}
    end
  end

  def delete(path, opts \\ []) do
    qparams = opts[:qparams]

    opts =
      Keyword.delete(opts, :qparams)
      |> Keyword.put(:headers, [auth_header()])

    base_url()
    |> Path.join(path)
    |> handle_qparams(qparams)
    |> Req.delete(opts)
    |> case do
      {:ok, %Req.Response{status: 200, body: _body, headers: _headers}} = resp ->
        resp

      {:ok, %Req.Response{status: 204, body: _body, headers: _headers}} = resp ->
        resp

      {:ok, %Req.Response{status: 429, headers: %{"retry-after" => [seconds_str]}}} ->
        if opts[:is_retry] do
          {:err, "Rate limit exceeded"}
        else
          seconds = String.to_integer(seconds_str)
          milliseconds = (seconds + 1) * 1000
          Logger.debug("Hit a rate limit, waiting #{milliseconds} milliseconds and retrying")
          :timer.sleep(milliseconds)
          new_opts = Keyword.merge(opts, is_retry: true)
          get(path, new_opts)
        end

      other ->
        {:err, other}
    end
  end

  defp auth_header() do
    auth_token = Application.get_env(:ex_doppler, :token)
    {"authorization", "Bearer #{auth_token}"}
  end

  defp base_url, do: "https://api.doppler.com/"

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
end
