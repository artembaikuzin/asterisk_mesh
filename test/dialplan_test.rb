require 'test_helper'

class DialplanTest < Minitest::Test
  include AsteriskMesh::Config
  include AsteriskMesh::NodeName

  def setup
    @dialplan = AsteriskMesh::Dialplan.new
    @node_from = { 'name' => 'test', 'host' => 'test.pro',
                   'operator_prefix' => 'operator', 'extension' => '2XX' }
    @node_to = { 'host' => 'n3.host.pro', 'extension' => '3XXX',
                 'prefix' => '55' }

    @password = SecureRandom.hex
  end

  def test_to_mesh_static

  end

  def test_from_mesh_static
    result = @dialplan.from_mesh_static(@node_from)
    puts result
  end
end
