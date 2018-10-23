# code liberally copied from the husky_shop app

~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

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
  set dev_mode: true
  set include_erts: false
  set cookie: String.to_atom(get_secret.("dev_cookie"))
end

environment :prod do
  set include_erts: true
  set include_src: false
  set vm_args: "rel/vm.args"
  set cookie: String.to_atom(get_secret.("prod_cookie"))
end

release :task_tracker do
  set version: current_version(:task_tracker)
  set applications: [
    :runtime_tools
  ]
end
