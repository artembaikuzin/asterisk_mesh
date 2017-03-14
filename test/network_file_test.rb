require 'test_helper'

class NetworkFileTest < Minitest::Test
  include SupportHelper

  def setup
    @net_file = AsteriskMesh::NetworkFile.new
  end

  def test_raise_empty_mesh
    assert_raises(AsteriskMesh::NetworkFile::EmptyMesh) {
      @net_file.parse(yml_file('no_mesh.yml')) }
  end

  def test_sets_default_output
    net = @net_file.parse(yml_file('no_output.yml'))

    output = "#{DIR}/mesh/"
    assert_equal(output, net['asterisk_mesh']['output'])
  end

  def test_static_ip
    assert_raises(AsteriskMesh::NetworkFile::NoStaticNodes) do
      @net_file.parse(yml_file('no_static_ip.yml'))
    end
  end

  def test_nil_nodes
    assert_raises(AsteriskMesh::NetworkFile::EmptyNodes) do
      @net_file.parse(yml_file('nil_nodes.yml'))
    end
  end

  def test_empty_nodes
    assert_raises(AsteriskMesh::NetworkFile::EmptyNodes) do
      @net_file.parse(yml_file('no_nodes.yml'))
    end
  end

  def test_one_node
    assert_raises(AsteriskMesh::NetworkFile::EmptyNodes) do
      @net_file.parse(yml_file('one_node.yml'))
    end
  end

  def test_set_node_name
    net = @net_file.parse(yml_file('no_names.yml'))

    assert_equal('host1', net['asterisk_mesh']['nodes'][0]['name'])
    assert_equal('host2.com', net['asterisk_mesh']['nodes'][1]['name'])
    assert_equal('node_2', net['asterisk_mesh']['nodes'][2]['name'])
  end

  def test_extension_exists
    assert_raises(AsteriskMesh::NetworkFile::EmptyExtension) do
      @net_file.parse(yml_file('no_extension.yml'))
    end
  end

  def test_sets_primary_digits
    net = @net_file.parse(yml_file('primary_digits.yml'))

    assert_equal(3, net['asterisk_mesh']['nodes'][0]['primary_digits'])
    assert_equal(3, net['asterisk_mesh']['nodes'][1]['primary_digits'])
    assert_equal(4, net['asterisk_mesh']['nodes'][2]['primary_digits'])
  end

  def test_ext_duplicates
    exception = assert_raises(AsteriskMesh::NetworkFile::DuplicateExtensions) do
      @net_file.parse(yml_file('ext_dups.yml'))
    end
    assert_equal('Extensions have duplicates: 1XX (2)', exception.message)
  end

  def test_name_duplicates
    exception = assert_raises(AsteriskMesh::NetworkFile::DuplicateNames) do
      @net_file.parse(yml_file('name_dups.yml'))
    end
    assert_equal('Names have duplicates: host1 (2), host2.com (2)',
                 exception.message)
  end

  def test_host_duplicates
    exception = assert_raises(AsteriskMesh::NetworkFile::DuplicateHosts) do
      @net_file.parse(yml_file('host_dups.yml'))
    end
    assert_equal('Hosts have duplicates: host2.com (2), host3.pro (3)',
                 exception.message)
  end
end
