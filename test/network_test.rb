require 'test_helper'

class NetworkTest < Minitest::Test
  include SupportHelper
  include AsteriskMesh::Config

  def setup
    @dialplan = AsteriskMesh::Dialplan.new
    @net_file = AsteriskMesh::NetworkFile.new
    @network = AsteriskMesh::Network.new(AsteriskMesh::IAX.new, @dialplan)
  end

  def test_only_static
    assert_nodes(:only_static)
  end

  def test_mixed
    assert_nodes(:mixed)
  end

  def test_mixed_one_static
    assert_nodes(:mixed_one_static)
  end

  private

  IAX_SECRET = 'SUPER_IAX_SECRET'

  def load_yml(name)
    @net_file.parse(yml_file(name))['asterisk_mesh']['nodes']
  end

  def load_support(method, node)
    load_results("#{SUPPORT}/#{method}", node)
  end

  def assert_nodes(method)
    SecureRandom.stub(:hex, IAX_SECRET) do
      static, dynamic = @network.build!(load_yml("#{method}.yml"))
      (static + dynamic).each do |node|
        extensions, iax, iax_register = load_support(method, node)

        assert_equal(iax, node[:iax])
        assert_equal(iax_register, node[:iax_register])
        assert_equal(extensions, extensions(node))
      end
    end
  end
end
