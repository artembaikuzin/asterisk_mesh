require 'test_helper'

class NetworkExportTest < Minitest::Test
  include SupportHelper

  def setup
    nf = AsteriskMesh::NetworkFile.new
    @network = nf.parse(yml_file('only_static.yml'))

    network = AsteriskMesh::Network.new(AsteriskMesh::IAX.new,
                                        AsteriskMesh::Dialplan.new)
    network.build!(@network['asterisk_mesh']['nodes'])

    @network_export = AsteriskMesh::NetworkExport.new
  end

  def test_node_export
    dir = Dir.mktmpdir

    begin
      @network['asterisk_mesh']['output'] = "#{dir}"
      @network_export.execute(@network)

      @network['asterisk_mesh']['nodes'].each do |node|
        extensions, iax, iax_register = load_results(dir, node)

        assert_equal(iax, node[:iax])
        assert_equal(iax_register, node[:iax_register])
        assert_equal(extensions, extensions(node))
      end
    ensure
      FileUtils.remove_entry dir
    end
  end
end
