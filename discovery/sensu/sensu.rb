require 'hinoki'
require 'set'

module MCollective
  class Discovery
    class Sensu
      def self.discover(filter, timeout, limit=0, client=nil)
        config = MCollective::Config.instance
        host = config.pluginconf["discovery.sensu.host"] || 'localhost'
        port = config.pluginconf["discovery.sensu.port"] || 4567
        api = Hinoki.new(host, port, config.pluginconf["discovery.sensu.user"], config.pluginconf["discovery.sensu.password"])
        clients = api.clients.all.map { |node| node['name'] }
        discovered = Set.new
        unless filter["identity"].empty?
          filter["identity"].each do |identity|
            if identity.match("^/")
              identity = Regexp.new(identity.gsub("\/", ""))
              discovered.merge(clients.grep(identity))
            elsif clients.include?(identity)
              discovered.add(identity)
            end
          end
        else
          discovered.merge(clients)
        end
        discovered.to_a
      end
    end
  end
end
