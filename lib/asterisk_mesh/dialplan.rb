module AsteriskMesh
  class Dialplan
    include Config
    include NodeName

    def to_mesh_static(node_from, node_to)
      to_mesh(node_from, node_to, true)
    end

    def to_mesh_dynamic(node_from, node_to)
      to_mesh(node_from, node_to, false)
    end

    def to_mesh_dynamic_dynamic_exten(node_from, node_to)
      <<~DIAL
        exten => _#{extension(node_from, node_to)},1,NoOp
        same => n,Set(CALLERID(all)=#{cid_prefix(node_from, node_to)}${CALLERID(num):-#{node_from['primary_digits']}})
      DIAL
    end

    def to_mesh_dynamic_dynamic(static_node, node_from, node_to)
      <<~DIAL
        same => n,Dial(IAX2/#{node_name_dynamic(static_node, node_from)}/${EXTEN:-#{node_to['primary_digits']}},#{DIAL_DELAY},rtT)
      DIAL
    end

    def to_mesh_dynamic_dynamic_hangup
      "same => n,Hangup\n\n"
    end

    def from_mesh_static(node_from)
      <<~DIAL
        exten => _#{node_from['extension']},1,NoOp
        same => n,Dial(SIP/#{node_from['operator_prefix']}${EXTEN},#{DIAL_DELAY},rtT)
        same => n,Hangup

      DIAL
    end

    def from_mesh_dynamic(static_node, dynamic_node)
      <<~DIAL
        ; Transit traffic to dynamic node #{dynamic_node['name']}
        exten => _#{dynamic_node['extension']},1,NoOp
        same => n,Dial(IAX2/#{node_name_dynamic(static_node, dynamic_node)}/${EXTEN},#{DIAL_DELAY},rtT)
        same => n,Hangup

      DIAL
    end

    def to_mesh_context
      "[#{CONTEXT_TO_MESH}]\n"
    end

    def from_mesh_context
      "[#{CONTEXT_FROM_MESH}]\n"
    end

    private

    def to_mesh(node_from, node_to, static = true)
      node_to_name = if static
                       node_name(node_to)
                     else
                       node_name_dynamic(node_from, node_to)
                     end
      <<~DIAL
        exten => _#{extension(node_from, node_to)},1,NoOp
        same => n,Set(CALLERID(all)=#{cid_prefix(node_from, node_to)}${CALLERID(num):-#{node_from['primary_digits']}})
        same => n,Dial(IAX2/#{node_to_name}/${EXTEN:-#{node_to['primary_digits']}},#{DIAL_DELAY},rtT)
        same => n,Hangup

      DIAL
    end

    def extension(node_from, node_to)
      "#{node_from['prefix']}#{node_to['prefix']}#{node_to['extension']}"
    end

    def cid_prefix(node_from, node_to)
      "#{node_to['prefix']}#{node_from['prefix']}"
    end
  end
end
