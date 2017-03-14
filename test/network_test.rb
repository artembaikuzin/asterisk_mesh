require 'test_helper'

class NetworkTest < Minitest::Test
  include SupportHelper
  include AsteriskMesh::Config

  def setup
    @dialplan = AsteriskMesh::Dialplan.new

    @network = AsteriskMesh::Network.new(
      AsteriskMesh::IAX.new,
      @dialplan)

    @net_file = AsteriskMesh::NetworkFile.new
  end

  def test_only_static
    nodes = @network.build!(load_yml('only_static.yml'))
    nodes.each do |node|
      iax = load_result('only_static', node['name'], 'iax.conf')
      assert_equal(iax, node[:iax])

      iax_register = load_result('only_static', node['name'],
                                 'iax_register.conf')
      assert_equal(iax_register, node[:iax_register])

      dialplan = load_result('only_static', node['name'],
                             'extensions.conf')

      assert_equal(dialplan, node[:dialplan_to_context] + node[:dialplan_to] +
        node[:dialplan_from_context] + node[:dialplan_from])
    end

  end

  def load_yml(name)
    @net_file.parse(yml_file(name))['asterisk_mesh']['nodes']
  end

  def load_result(test, host_name, file_name)
    File.read("#{SUPPORT}#{test}/#{host_name}/#{file_name}")
  end
end
