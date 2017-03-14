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

    def register_dynamic(node, password)
      "register => #{node_name(node)}:#{password}@#{node['host']}\n"
    end

    def friend_dynamic(node, password)
      <<~IAX
        [#{node_name(node)}]
        type=friend
        host=dynamic
        context=#{CONTEXT_FROM_MESH}
        secret=#{password}
        username=#{node_name(node)}

      IAX
    end
  end
end
