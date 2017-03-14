require 'test_helper'

class IAXTest < Minitest::Test
  include AsteriskMesh::Config
  include AsteriskMesh::NodeName

  def setup
    @iax = AsteriskMesh::IAX.new
    @node = { 'name' => 'test', 'host' => 'test.pro' }
    @password = SecureRandom.hex
  end

  def test_friend_static
    result = @iax.friend_static(@node)

    expect = <<~IAX
      [#{node_name(@node)}]
      type=friend
      host=#{@node['host']}
      context=#{CONTEXT_FROM_MESH}

    IAX

    assert_equal(expect, result)
  end

  def test_register_dynamic
    result = @iax.register_dynamic(@node, @password)
    expect = "register => #{node_name(@node)}:#{@password}@#{@node['host']}\n"

    assert_equal(expect, result)
  end

  def test_friend_dynamic
    result = @iax.friend_dynamic(@node, @password)
    expect = <<~IAX
      [#{node_name(@node)}]
      type=friend
      host=dynamic
      context=#{CONTEXT_FROM_MESH}
      secret=#{@password}
      username=#{node_name(@node)}

    IAX

    assert_equal(expect, result)
  end
end
