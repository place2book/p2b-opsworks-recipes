node[:deploy].each do |application, deploy|
  next unless node[:opsworks][:instance][:hostname] == 'travify-booking'

  deploy = node[:deploy][application]

  bash "update-crontab-#{application}" do
    layers = node[:opsworks][:instance][:layers]

    cwd "#{deploy[:deploy_to]}/current"
    user 'deploy'
    code "bundle exec whenever --set environment=#{deploy[:rails_env]} --update-crontab #{application} --roles #{layers.join(',')}"
    only_if "cd #{deploy[:deploy_to]}/current && bundle show whenever"
  end
end
