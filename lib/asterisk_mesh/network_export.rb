require 'fileutils'

module AsteriskMesh
  class NetworkExport
    def execute(network)
      mesh = network['asterisk_mesh']
      output = mesh['output']

      mesh['nodes'].each do |node|
        node_dir = "#{output}/#{node['name']}"
        FileUtils.mkdir_p(node_dir)

        export_node(node, node_dir)
      end
    end

    private

    DIALPLAN = 'extensions.conf'.freeze
    IAX = 'iax.conf'.freeze
    IAX_REGISTER = 'iax_register.conf'.freeze

    def export_node(node, node_dir)
      File.open("#{node_dir}/#{DIALPLAN}", 'w') do |f|
        f.write(node[:dialplan_to_context])
        f.write(node[:dialplan_to])

        f.write(node[:dialplan_from_context])
        f.write(node[:dialplan_from])
      end

      File.open("#{node_dir}/#{IAX}", 'w') do |f|
        f.write(node[:iax])
      end

      File.open("#{node_dir}/#{IAX_REGISTER}", 'w') do |f|
        f.write(node[:iax_register])
      end
    end
  end
end
