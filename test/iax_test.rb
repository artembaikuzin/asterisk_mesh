require 'test_helper'

class IAXTest < Minitest::Test
  include AsteriskMesh::Config
  include AsteriskMesh::NodeName

  def setup
    @iax = AsteriskMesh::IAX.new
    @node_from = { 'name' => 'test', 'host' => 'test.pro',
                   'operator_prefix' => 'operator', 'extension' => '2XX',
                   'primary_digits' => 3 }

    @node_from_dyn = @node_from.dup
    @node_from_dyn.delete('host')

    @node_to = { 'host' => 'n3.host.pro', 'extension' => '3XXX',
                 'name' => 'n3.host.pro',
                 'prefix' => '55', 'primary_digits' => 4 }

    @password = SecureRandom.hex
  end

  def test_friend_static
    result = @iax.friend_static(@node_from)

    expect = <<~IAX
      [#{node_name(@node_from)}]
      type=friend
      host=#{@node_from['host']}
      context=#{CONTEXT_FROM_MESH}

    IAX

    assert_equal(expect, result)
  end

  def test_register_dynamic
    result = @iax.register_dynamic(@node_from_dyn, @node_to, @password)
    assert_equal(<<~IAX, result)
      register => mesh-test-n3.host.pro:#{@password}@n3.host.pro
    IAX
  end

  def test_friend_dynamic
    result = @iax.friend_dynamic(@node_from_dyn, @node_to, @password)

    expect = <<~IAX
      [mesh-test-n3.host.pro]
      type=friend
      host=dynamic
      context=from-mesh
      secret=#{@password}
      username=mesh-test-n3.host.pro

    IAX

    assert_equal(expect, result)
  end

  def test_friend_static_password
    result = @iax.friend_static_password(@node_from_dyn, @node_to, @password)

    assert_equal(<<~IAX, result)
      [mesh-test-n3.host.pro]
      type=friend
      host=n3.host.pro
      context=from-mesh
      secret=#{@password}
      username=mesh-test-n3.host.pro

    IAX
  end
end
