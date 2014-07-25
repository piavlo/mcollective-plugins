metadata    :name        => "sensu",
            :description => "Sensu based discovery for node identities and their check subscriptions",
            :author      => "Piavlo <lolitushka@gmail.com>",
            :license     => "MIT",
            :version     => "0.2",
            :url         => "https://github.com/piavlo/mcollective-plugins/tree/master/discovery/sensu",
            :timeout     => 0

discovery do
    capabilities :identity, :classes
end
