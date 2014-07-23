metadata    :name        => "sensu",
            :description => "Sensu based discovery for node identities",
            :author      => "Piavlo <lolitushka@gmail.com>",
            :license     => "MIT",
            :version     => "0.1",
            :url         => "https://github.com/piavlo/mcollective-plugins/tree/master/discovery/sensu",
            :timeout     => 0

discovery do
    capabilities :identity
end
