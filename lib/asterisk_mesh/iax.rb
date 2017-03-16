module AsteriskMesh
  class IAX
    include Config
    include NodeName

    def friend_static(node)
      <<~IAX
        [#{node_name(node)}]
        type=friend
        host=#{node['host']}
        context=#{CONTEXT_FROM_MESH}

      IAX
    end

    def register_dynamic(node_from, node_to, password)
      "register => #{node_name_dynamic(node_from, node_to)}:#{password}@#{node_to['host']}\n"
    end

    def friend_dynamic(node_from, node_to, password)
      <<~IAX
        [#{node_name_dynamic(node_from, node_to)}]
        type=friend
        host=dynamic
        context=#{CONTEXT_FROM_MESH}
        secret=#{password}
        username=#{node_name_dynamic(node_from, node_to)}

      IAX
    end

    def friend_static_password(node_from, node_to, password)
      <<~IAX
        [#{node_name_dynamic(node_from, node_to)}]
        type=friend
        host=#{node_to['host']}
        context=#{CONTEXT_FROM_MESH}
        secret=#{password}
        username=#{node_name_dynamic(node_from, node_to)}

      IAX
    end
  end
end
