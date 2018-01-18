var config = require('./config');

var hostNames = function (host) {
    var hosts = [host, host.replace(/^lnx-ap-/, '')];

    if (config.hosts.domains) {
        var h = [];
        hosts.forEach(function (key, idx) {
            if (idx) {
                if (host[idx - 1] === key) {
                    key = null;
                }
            }

            if (key) {
                h.push(key);
                config.hosts.domains.forEach(function (val) {
                    h.push(key + '.' + val);
                });
            }
        });
        hosts = h;
    }

    return hosts.join('\t');
};

var cloudstack = new (require('cloudstack'))({
    apiUri: config.api_uri, // overrides process.env.CLOUDSTACK_API_URI
    apiKey: config.api_key, // overrides process.env.CLOUDSTACK_API_KEY
    apiSecret: config.api_secret // overrides process.env.CLOUDSTACK_API_SECRET
});

cloudstack.exec('listVirtualMachines', {}, function (error, result) {
    if (error) {
        throw error;
    }
    if (result) {
        result.virtualmachine.forEach(function (machine) {
            console.log(
                ((machine.publicip) ? '' : '#') +
                machine.publicip + '\t' + 
                hostNames(machine.name )
            );
        });
    }
});