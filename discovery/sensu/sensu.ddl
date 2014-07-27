metadata    :name        => "sensu",
            :description => "Sensu based discovery for node identities and their check subscriptions as classes and check statuses as facts",
            :author      => "Piavlo <lolitushka@gmail.com>",
            :license     => "MIT",
            :version     => "0.3",
            :url         => "https://github.com/piavlo/mcollective-plugins/tree/master/discovery/sensu",
            :timeout     => 0

discovery do
    capabilities :identity, :classes, :facts
end
