module AsteriskMesh
  module NodeName
    include Config

    def node_name(node)
      "#{GLOBAL_PREFIX}-#{node['name']}"
    end
  end
end
