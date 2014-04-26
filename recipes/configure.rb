service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action :nothing # only define so that it can be restarted if the config changed
end

template "#{node['haproxy']['conf_dir']}/haproxy.cfg" do
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, "service[haproxy]"
  variables(
    :defaults_options => haproxy_defaults_options,
    :defaults_timeouts => haproxy_defaults_timeouts
  )
end

execute "echo 'checking if HAProxy is not running - if so start it'" do
  not_if "pgrep haproxy"
  notifies :start, "service[haproxy]"
end
