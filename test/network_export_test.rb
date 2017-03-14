require 'test_helper'

class NetworkExportTest < Minitest::Test
  include SupportHelper

  def setup
    @dialplan = AsteriskMesh::Dialplan.new
    @network_export = AsteriskMesh::NetworkExport.new(@dialplan)
  end

  def test_node_export

  end
end
