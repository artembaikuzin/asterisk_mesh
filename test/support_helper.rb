module SupportHelper
  DIR = Dir.getwd
  SUPPORT = "#{DIR}/test/support"

  def yml_file(name)
    "#{SUPPORT}/#{name}"
  end

  def extensions(node)
    node[:dialplan_to_context] + node[:dialplan_to] +
      node[:dialplan_from_context] + node[:dialplan_from]
  end

  def load_results(base_dir, node)
    path = "#{base_dir}/#{node['name']}"

    extensions = "#{path}/extensions.conf"
    iax = "#{path}/iax.conf"
    iax_register = "#{path}/iax_register.conf"

    [File.exist?(extensions) ? File.read(extensions) : '',
     File.exist?(iax) ? File.read(iax) : '',
     File.exist?(iax_register) ? File.read(iax_register) : '']
  end
end
