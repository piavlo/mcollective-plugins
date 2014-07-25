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

        identified = Set.new
        unless filter["identity"].empty?
          filter["identity"].each do |identity|
            if identity.match("^/")
              identity = Regexp.new(identity.gsub("\/", ""))
              identified.merge(clients.grep(identity))
            elsif clients.include?(identity)
              identified.add(identity)
            end
          end
        else
          identified.merge(clients)
        end

        classified = Set.new
        unless filter["cf_class"].empty?
          api.clients.all.each do |node|
            filter["cf_class"].each do |role|
              if node['subscriptions'].include?(role)
                classified.add(node['name'])
                break
              end
            end
          end
        end

        if not filter["identity"].empty? and not filter["cf_class"].empty?
          discovered = identified.intersection(classified)
        elsif not filter["identity"].empty?
          discovered = identified
        elsif not filter["cf_class"].empty?
          discovered = classified
        else
          discovered = clients
        end
        discovered.to_a
      end
    end
  end
end
