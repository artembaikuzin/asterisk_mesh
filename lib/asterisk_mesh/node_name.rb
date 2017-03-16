module AsteriskMesh
  module NodeName
    include Config

    ##
    # Generate peer name for static nodes: mesh-name
    #
    def node_name(node)
      "#{GLOBAL_PREFIX}-#{node['name']}"
    end

    ##
    # Generate peer name. Dynamic node always goes first (mesh-dyn-static).
    #
    def node_name_dynamic(node_from, node_to)
      node = if node_from['host'].nil?
               "#{node_from['name']}-#{node_to['name']}"
             else
               "#{node_to['name']}-#{node_from['name']}"
             end

      "#{GLOBAL_PREFIX}-#{node}"
    end
  end
end
