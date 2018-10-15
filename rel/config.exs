# taken from course notes
get_secret = fn name ->
  base = Path.expand("~/.config/task_tracker")
  File.mkdir_p!(base)
  path = Path.join(base, name)
  unless File.exists?(path) do
    secret = Base.encode16(:crypto.strong_rand_bytes(32))
    File.write!(path, secret)
  end
  String.trim(File.read!(path))
end

environment :dev do
  ... 
  # Dev secrets are less important, but we're here already.
  set cookie: String.to_atom(get_secret.("dev_cookie"))
end

environment :prod do
  ... 
  set cookie: String.to_atom(get_secret.("prod_cookie"))
end
