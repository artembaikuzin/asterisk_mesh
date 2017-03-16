require 'test_helper'

class NodeNameTest < Minitest::Test
  include AsteriskMesh::NodeName

  def setup
    @node_from = { 'name' => 'test', 'host' => 'test.pro',
                   'operator_prefix' => 'operator', 'extension' => '2XX',
                   'primary_digits' => 3 }

    @node_to = { 'name' => 'test2', 'host' => 'test2.pro',
                 'operator_prefix' => 'operator', 'extension' => '3XX',
                 'primary_digits' => 3 }
  end

  def test_node_name
    assert_equal("#{GLOBAL_PREFIX}-#{@node_from['name']}",
                 node_name(@node_from))
  end

  def test_node_name_dynamic
    node_from = @node_from.dup
    node_from.delete('host')

    assert_equal('mesh-test-test2', node_name_dynamic(node_from, @node_to))
    assert_equal('mesh-test-test2', node_name_dynamic(@node_to, node_from))
  end
end
