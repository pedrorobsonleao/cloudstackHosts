var config = require('./config');

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
                machine.name + '\t' +
                machine.name.replace(/^lnx-ap-/, '')
            );
        });
    }
});