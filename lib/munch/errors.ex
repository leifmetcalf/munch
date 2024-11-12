defmodule Munch.NotAuthorizedError do
  defexception message: "User is not authorized to access this resource."
end
