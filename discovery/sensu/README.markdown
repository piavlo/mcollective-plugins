# mcollective-sensu-discovery #

MCollective discovery plugin that uses Sensu API server as its data source.

List all clients found in the sensu api, or those matching a given search.

# Installation

Copy sensu.ddl and sensu.rb to the discovery directory in your
MCollective libdir.  You will need to install the `hinoki` gem into the
Ruby running mcollective.

    $ gem install hinoki --no-rdoc --no-ri


# Configuration #

This plugin takes its (optional) configuration from your mcollective client.cfg
if no configuration is given it will connect to localhost:4567.

    plugin.discovery.sensu.host = somelhost
    plugin.discovery.sensu.port = 4567
    plugin.discovery.sensu.user = someuser
    plugin.discovery.sensu.password = somepassword

# Usage #

Select the Sensu discovery plugin by including `--dm sensu` on your mco
commandline.  By default, this will discover all Sensu clients.

Example: 'mco rpc rpcutil ping' all nodes known to Sensu Api

    $ mco rpc rpcutil ping --dm sensu


The `-I` option (identity) limits discovered nodes by their Sensu client
name.  When the -I option is specified multiple times, nodes matching any
item will be discovered. Regular expressions are supported.

Example: node names containing 'blah'

    $ mco rpc rpcutil ping --dm sensu -I /blah/

Example: node 'foo.example.com', and node names containing 'blah'

    $ mco rpc rpcutil ping --dm sensu -I /blah/ -I foo.example.com

The `-C` option (class) limits discovered nodes by their Sensu client check subscriptions.
When the -C option is specified multiple times, nodes matching any item will be discovered.

Example: node names with mysql subscriptions

    $ mco rpc rpcutil ping --dm sensu -C mysql

Example: node names containing both 'blah' and mysql subscriptions

    $ mco rpc rpcutil ping --dm sensu -I /blah/ -C mysql


The `-F` option (fact) limits discovered nodes by their Sensu client specific check status
When the -F option is specified multiple times, nodes matching any item will be discovered.

Example: node names whoose cpu_check is in WARNING status

    $ mco rpc rpcutil ping --dm sensu -F cpu_check=WARNING

Example: node names whoose cpu_check is in WARNING or CRITICAL status

    $ mco rpc rpcutil ping --dm sensu -F cpu_check=WARNING -F cpu_check=CRITICAL
