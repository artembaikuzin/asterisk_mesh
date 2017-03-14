require 'test_helper'

class NetworkTest < Minitest::Test
  include SupportHelper
  include AsteriskMesh::Config

  def setup
    @network = AsteriskMesh::Network.new(
      AsteriskMesh::IAX.new,
      AsteriskMesh::Dialplan.new)

    @net_file = AsteriskMesh::NetworkFile.new
  end

  def test_traverse
    return
    nodes = @network.build!(load_yml('only_static.yml'))
    nodes.each do |node|
      puts "NODE: #{node['name']}:"
      puts node[:dialplan_to]
      puts node[:dialplan_from]
      puts node[:iax]
    end

    # nodes = @network.build!(load_yml('only_static.yml'))
    #
    # puts "size: #{nodes.size}"
    #
    # File.open("#{DIR}/output.conf", 'w') do |f|
    #   nodes.each do |node|
    #     f.write("; node: #{node['name']}\n")
    #     f.write(node[:iax])
    #   end
    # end
    #
  end

  def load_yml(name)
    @net_file.parse(yml_file(name))['asterisk_mesh']['nodes']
  end
end
