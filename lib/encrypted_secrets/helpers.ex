defmodule EncryptedSecrets.Helpers do
  @moduledoc """
    Contains helper methods
  """

  @doc """
    Takes a map with string keys and recursively converts the keys to atoms.
     DO NOT USE ON USER-PROVIDED INPUT

    Returns `{:ok, map}`
  ## Examples
      iex> string_key_map = %{"foo" => %{"bar" => "baz"}}
      iex> Helpers.convert_map_keys({:ok, string_key_map})
      {:ok, %{foo: %{bar: "baz"}}}
  """
  def convert_map_keys({:ok, map}) do
    {:ok, to_atom_map(map)}
  end

  def convert_map_keys({:error, %{message: message}}) do
    {:error, message}
  end

  @doc """
    Appends a given file to .gitignore

    Returns `:ok | {:error, error}`
  """
  def append_to_gitignore(file_to_ignore) do
    gitignore_location = ".gitignore"
    message = "\n# Master key should never be in version control\n" <> file_to_ignore

    case File.exists?(gitignore_location) do
      true ->
        File.open!(gitignore_location, [:append], fn file ->
          IO.puts(file, message)
        end)

      _ ->
        {:error, ".gitignore not found"}
    end
  end

  defp to_atom_map(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), to_atom_map(v)} end)
  end

  defp to_atom_map(value) do
    value
  end
end
