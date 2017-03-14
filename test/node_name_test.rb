require 'test_helper'

class NodeNameTest < Minitest::Test
  include AsteriskMesh::NodeName

  def test_node_name
    node = { 'name' => 'test', 'host' => 'test.pro',
             'operator_prefix' => 'operator', 'extension' => '2XX',
             'primary_digits' => 3 }

    assert_equal("#{GLOBAL_PREFIX}-#{node['name']}", node_name(node))
  end
end
