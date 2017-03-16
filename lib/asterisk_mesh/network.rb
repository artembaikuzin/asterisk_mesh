require 'securerandom'

module AsteriskMesh
  class Network
    def initialize(iax, dialplan)
      @iax = iax
      @dialplan = dialplan
    end

    def build!(nodes)
      static_nodes, dynamic_nodes = init_nodes(nodes)

      build_static(static_nodes)

      return [static_nodes, dynamic_nodes] if dynamic_nodes.empty?

      build_dynamic(dynamic_nodes, static_nodes)

      [static_nodes, dynamic_nodes]
    end

    private

    def init_nodes(nodes)
      static = []
      dynamic = []

      nodes.each do |node|
        if node['host'].nil?
          dynamic << node
        else
          static << node
        end

        node[:iax] = ''
        node[:iax_register] = ''

        node[:dialplan_from_context] = @dialplan.from_mesh_context
        node[:dialplan_from] = ''

        node[:dialplan_to_context] = @dialplan.to_mesh_context
        node[:dialplan_to] = ''
      end

      [static, dynamic]
    end

    def build_static(nodes)
      nodes_to = nodes.drop(1)

      nodes.each do |node_from|
        node_from[:dialplan_from] << @dialplan.from_mesh_static(node_from)

        nodes_to.each do |node_to|
          node_from[:iax] << @iax.friend_static(node_to)
          node_to[:iax] << @iax.friend_static(node_from)

          node_from[:dialplan_to] << @dialplan.to_mesh_static(node_from, node_to)
          node_to[:dialplan_to] << @dialplan.to_mesh_static(node_to, node_from)
        end

        nodes_to = nodes_to.drop(1)
      end

      nodes
    end

    def build_dynamic(dynamic_nodes, static_nodes)
      dynamic_to_all_static(dynamic_nodes, static_nodes)

      return if dynamic_nodes.size < 2

      dynamic_to_dynamic(dynamic_nodes, static_nodes)
    end

    def dynamic_to_all_static(dynamic_nodes, static_nodes)
      dynamic_nodes.each do |node_from|
        node_from[:dialplan_from] << @dialplan.from_mesh_static(node_from)

        static_nodes.each do |node_to|
          password = SecureRandom.hex

          node_from[:iax] << @iax.friend_static_password(node_from, node_to,
                                                         password)
          node_from[:iax_register] << @iax.register_dynamic(node_from, node_to,
                                                            password)
          node_to[:iax] << @iax.friend_dynamic(node_from, node_to, password)

          node_from[:dialplan_to] << @dialplan.to_mesh_dynamic(node_from,
                                                               node_to)
          node_to[:dialplan_to] << @dialplan.to_mesh_dynamic(node_to, node_from)

          # Add transit traffic rules for [from-mesh] context to static node
          # only in case when we have enough dynamic nodes:
          if dynamic_nodes.size >= 2
            node_to[:dialplan_from] <<
              @dialplan.from_mesh_dynamic(node_to, node_from)
          end
        end
      end
    end

    ##
    # Create both way connection between two dynamic nodes via one static node
    #
    def dynamic_to_dynamic(dynamic_nodes, static_nodes)
      nodes_to = dynamic_nodes.drop(1)

      i = 0
      dynamic_nodes.each do |node_from|
        nodes_to.each do |node_to|
          node_from[:dialplan_to] << @dialplan.to_mesh_dynamic_dynamic_exten(
            node_from, node_to)
          node_to[:dialplan_to] << @dialplan.to_mesh_dynamic_dynamic_exten(
            node_to, node_from)

          static_nodes.size.times do
            static_node = next_static_node(static_nodes, i)

            node_from[:dialplan_to] << @dialplan.to_mesh_dynamic_dynamic(
              static_node, node_from, node_to)

            node_to[:dialplan_to] << @dialplan.to_mesh_dynamic_dynamic(
              static_node, node_to, node_from)

            i += 1
          end

          node_from[:dialplan_to] << @dialplan.to_mesh_dynamic_dynamic_hangup
          node_to[:dialplan_to] << @dialplan.to_mesh_dynamic_dynamic_hangup
        end

        nodes_to = nodes_to.drop(1)
      end
    end

    def next_static_node(static_nodes, i)
      static_nodes[i % static_nodes.size]
    end
  end
end
