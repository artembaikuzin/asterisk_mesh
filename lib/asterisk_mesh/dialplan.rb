module AsteriskMesh
  class Dialplan
    include Config
    include NodeName

    def to_mesh_static(node_from, node_to)
      <<~DIAL
        exten => _#{node_from['prefix']}#{node_to['extension']},1,NoOp
        same => n,Set(CALLERID(all)=#{node_to['prefix']}${CALLERID(num):-#{node_to['primary_digits']}})
        same => n,Dial(IAX2/#{node_name(node_to)}/${EXTEN:-#{node_to['primary_digits']}},#{DIAL_DELAY},rtT)
        same => n,Hangup

      DIAL
    end

    def from_mesh_static(node_from)
      <<~DIAL
        exten => _#{node_from['prefix']}#{node_from['extension']},1,NoOp
        same => n,Set(CALLERID(all)=#{node_from['prefix']}${CALLERID(num):-#{node_from['primary_digits']})
        same => n,Dial(SIP/#{node_from['operator_prefix']}{EXTEN:-#{node_from['primary_digits']}},#{DIAL_DELAY},rtT)
        same => n,Hangup

      DIAL
    end

    def to_mesh_context
      "[to-mesh]\n"
    end

    def from_mesh_context
      "[from-mesh]\n"
    end
  end
end
