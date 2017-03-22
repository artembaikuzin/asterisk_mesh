require 'yaml'

module AsteriskMesh
  class NetworkFile
    class NetworkFileError < RuntimeError; end
    class EmptyMesh < NetworkFileError; end
    class NoStaticNodes < NetworkFileError; end
    class EmptyNodes < NetworkFileError; end
    class EmptyExtension < NetworkFileError; end
    class DuplicateExtensions < NetworkFileError; end
    class DuplicateNames < NetworkFileError; end
    class DuplicateHosts < NetworkFileError; end

    attr_reader :network

    def parse(file)
      @network = YAML.load_file(file)

      if @network.nil? || @network['asterisk_mesh'].nil?
        raise EmptyMesh.new('asterisk_mesh key is absent in yml file')
      end

      default_output
      check_nodes

      @network
    end

    private

    DEFAULT_OUTPUT = 'mesh/'.freeze

    def default_output
      output = @network['asterisk_mesh']['output']

      if output.nil?
        @network['asterisk_mesh']['output'] = "#{Dir.getwd}/#{DEFAULT_OUTPUT}"
      elsif output[output.size - 1] != '/'
        @network['asterisk_mesh']['output'] = "#{output}/"
      end
    end

    def check_nodes
      nodes = @network['asterisk_mesh']['nodes']

      nodes_size(nodes)

      no_static_nodes = true
      node_id = 0

      ext_dups = {}
      name_dups = {}
      host_dups = {}

      nodes.each do |node|
        node_extension(node)
        node_primary_digits(node)
        node_name(node, node_id)

        add_ext_dup(ext_dups, node)
        add_name_dup(name_dups, node)
        add_host_dup(host_dups, node)

        no_static_nodes = false if no_static_nodes && !node['host'].nil?
        node_id += 1
      end

      check_unique_exts(ext_dups)
      check_unique_names(name_dups)
      check_unique_hosts(host_dups)

      raise NoStaticNodes.new('At least one node should have static ip ' \
        'address or hostname') if no_static_nodes
    end

    def nodes_size(nodes)
      if nodes.nil? || nodes.size < 2
        raise EmptyNodes.new('At least two nodes should be defined to ' \
          'create a mesh network')
      end
    end

    def node_name(node, node_id)
      if node['name'].nil?
        node['name'] = if node['host'].nil?
                         "node_#{node_id}"
                       else
                         node['host']
                       end
      end
    end

    def node_extension(node)
      if node['extension'].nil?
        raise EmptyExtension.new("Node should have extension " \
          "key: #{node.inspect}")
      end
    end

    def node_primary_digits(node)
      if node['primary_digits'].nil?
        node['primary_digits'] = node['extension'].size
      end
    end

    def add_ext_dup(ext_dupes, node)
      ext = "#{node['prefix']}#{node['extension']}"
      add_dup(ext_dupes, ext)
    end

    def add_name_dup(name_dups, node)
      name = node['name']
      add_dup(name_dups, name)
    end

    def add_host_dup(host_dups, node)
      host = node['host']
      add_dup(host_dups, host)
    end

    def add_dup(hash, name)
      if hash[name].nil?
        hash[name] = 1
      else
        hash[name] += 1
      end
    end

    def check_unique_exts(ext_dups)
      check_uniques(ext_dups, DuplicateExtensions, 'Extensions')
    end

    def check_unique_names(name_dups)
      check_uniques(name_dups, DuplicateNames, 'Names')
    end

    def check_unique_hosts(host_dups)
      check_uniques(host_dups, DuplicateHosts, 'Hosts', true)
    end

    def check_uniques(hash, error_class, message_name, skip_nil = false)
      dupes = []

      hash.each do |key, value|
        next if skip_nil && key.nil?
        dupes << "#{key} (#{value})" if value > 1
      end

      if dupes.size > 0
        raise error_class.new("#{message_name} have " \
          "duplicates: #{dupes.join(', ')}")
      end
    end
  end
end
