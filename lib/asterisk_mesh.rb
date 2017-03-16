require 'asterisk_mesh/version'
require 'asterisk_mesh/config'
require 'asterisk_mesh/network_file'
require 'asterisk_mesh/network'
require 'asterisk_mesh/network_export'
require 'asterisk_mesh/node_name'
require 'asterisk_mesh/iax'
require 'asterisk_mesh/dialplan'

require 'optparse'

module AsteriskMesh
  class Main
    def execute
      options = {}

      OptionParser.new do |parser|
        parser.banner = 'Usage: asterisk_mesh.rb [options] [network_file]'

        parser.on('-n NETWORK_FILE', '--network=NETWORK_FILE',
                  'network_file.yml') do |file|
          options[:network_file] = file
        end

        parser.on('-v', '--version', 'Prints version number') do
          puts "asterisk_mesh #{AsteriskMesh::VERSION}"
          exit
        end
      end.parse!

      network_file = if options.key?(:network_file)
                       options[:network_file]
                     else
                       "#{Dir.getwd}/#{DEFAULT_NETWORK_FILE}"
                     end

      print 'Parsing network file...'
      nf = NetworkFile.new
      mesh = nf.parse(network_file)
      puts 'OK'

      print 'Building network...'
      network = Network.new(IAX.new, Dialplan.new)
      static, dynamic = network.build!(mesh['asterisk_mesh']['nodes'])
      puts 'OK'

      print "Exporting nodes to #{mesh['asterisk_mesh']['output']}..."
      export = NetworkExport.new
      export.execute(mesh)
      puts 'OK'

      puts "#{mesh['asterisk_mesh']['nodes'].size} nodes have been exported" \
        " (#{static.size} static, #{dynamic.size} dynamic):"

      mesh['asterisk_mesh']['nodes'].each do |node|
        puts "#{node['host'].nil? ? 'DYNAMIC' : 'STATIC'}: #{node['name']}"
      end
    end

    private

    DEFAULT_NETWORK_FILE = 'asterisk_mesh.yml'.freeze
  end
end
