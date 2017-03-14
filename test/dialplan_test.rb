require 'test_helper'

class DialplanTest < Minitest::Test
  include AsteriskMesh::Config
  include AsteriskMesh::NodeName

  def setup
    @dialplan = AsteriskMesh::Dialplan.new
    @node_from = { 'name' => 'test', 'host' => 'test.pro',
                   'operator_prefix' => 'operator', 'extension' => '2XX',
                   'primary_digits' => 3 }

    @node_to = { 'host' => 'n3.host.pro', 'extension' => '3XXX',
                 'prefix' => '55', 'primary_digits' => 4 }

    @password = SecureRandom.hex
  end

  def test_to_mesh_static
    result = @dialplan.to_mesh_static(@node_from, @node_to)

    assert_equal(<<~DIALPLAN, result)
      exten => _3XXX,1,NoOp
      same => n,Set(CALLERID(all)=55${CALLERID(num):-4})
      same => n,Dial(IAX2/mesh-/${EXTEN:-4},60,rtT)
      same => n,Hangup

    DIALPLAN
  end

  def test_from_mesh_static
    result = @dialplan.from_mesh_static(@node_from)

    assert_equal(<<~DIALPLAN, result)
      exten => _2XX,1,NoOp
      same => n,Set(CALLERID(all)=${CALLERID(num):-3)
      same => n,Dial(SIP/operator{EXTEN:-3},60,rtT)
      same => n,Hangup

    DIALPLAN
  end

  def test_to_mesh_context
    assert_equal("[to-mesh]\n", @dialplan.to_mesh_context)
  end

  def test_from_mesh_context
    assert_equal("[from-mesh]\n", @dialplan.from_mesh_context)
  end
end
