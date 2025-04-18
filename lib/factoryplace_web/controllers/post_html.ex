defmodule FactoryplaceWeb.PostHTML do
  use FactoryplaceWeb, :html

  embed_templates "post_html/*"

  @doc """
  Renders a post form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def post_form(assigns)

  @doc """
  Renders a comment form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def comment_form(assigns)
end
