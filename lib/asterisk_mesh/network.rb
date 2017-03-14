module AsteriskMesh
  class Network
    def initialize(iax, dialplan)
      @iax = iax
      @dialplan = dialplan
    end

    def build!(nodes)
      static_nodes, dynamic_nodes = build_static(nodes)
      build_dynamic(dynamic_nodes, static_nodes)

      nodes
    end

    private

    def build_static(nodes)
      static_nodes = []
      dynamic_nodes = []

      nodes_to = nodes.drop(1)

      nodes.each do |node_from|
        if node_from['host'].nil?
          dynamic_nodes << node_from
          next
        else
          static_nodes << node_from
        end

        node_from[:dialplan_from] << @dialplan.from_mesh_static(node_from)

        nodes_to.each do |node_to|
          next if node_to['host'].nil?

          node_from[:iax] << @iax.friend_static(node_to)
          node_to[:iax] << @iax.friend_static(node_from)

          node_from[:dialplan_to] << @dialplan.to_mesh_static(node_from, node_to)
          node_to[:dialplan_to] << @dialplan.to_mesh_static(node_to, node_from)
        end

        nodes_to = nodes_to.drop(1)
      end

      [static_nodes, dynamic_nodes]
    end

    def build_dynamic(dynamic_nodes, static_nodes)

    end
  end
end
