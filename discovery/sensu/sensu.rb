require 'hinoki'
require 'set'

module MCollective
  class Discovery
    class Sensu
      def self.discover(filter, timeout, limit=0, client=nil)
        config = MCollective::Config.instance
        host = config.pluginconf['discovery.sensu.host'] || 'localhost'
        port = config.pluginconf['discovery.sensu.port'] || 4567
        api = Hinoki.new(host, port, config.pluginconf['discovery.sensu.user'], config.pluginconf['discovery.sensu.password'])
        clients = api.clients.all.map { |node| node['name'] }

        identified = Set.new
        unless filter['identity'].empty?
          filter['identity'].each do |identity|
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
        unless filter['cf_class'].empty?
          api.clients.all.each do |node|
            filter['cf_class'].each do |role|
              if node['subscriptions'].include?(role)
                classified.add(node['name'])
                break
              end
            end
          end
        else
          classified.merge(clients)
        end

        factorized = Set.new
        unless filter['fact'].empty?
          severities = { 'OK' => 0, 'WARNING' => 1, 'CRITICAL' => 2, 'UNKNOWN' => 3 }

          filter['fact'].each do |fact|
            raise "The sensu discovery method supports equality oprator" unless fact[:operator] == "=="
            unless severities.has_key?(fact[:value])
              velid_values_msg = severities.keys.inject(''){|msg, severity| msg.concat(" #{severity}")}
              raise "The sensu discovery method supports only following fact values:#{velid_values_msg}"
            end
          end

          api.clients.all.each do |client|
            history = api.clients.history(client['name'])
            filter['fact'].each do |fact|
              checks = history.select{|check| check['check'] == fact[:fact]}
              unless checks.empty?
                factorized.add(client['name']) if checks.first['last_status'] == severities[fact[:value]]
              end
            end
          end
        else
          factorized.merge(clients)
        end

        return identified.intersection(classified.intersection(factorized)).to_a
      end
    end
  end
end
