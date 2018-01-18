# cloudstackHosts - Sync hosts Apache-CloudStack -> local hosts
Provide a syncronization between Apache-CloudStack and file *hosts* in local machine.

# Instalation
* Checkout repository.
* put in your hosts file.
```
$ echo -e '#cloudhosts start\n#cloudhosts end' >>/etc/hosts
```
* edit file *./lib/config.json* and update informations.

# Tree
```
$ tree
.
├── cloudstackHosts.sh                  # main bash script
├── lib
│   ├── config.json                     # authentication config file
│   ├── LICENSE -> ../LICENSE           # GPL License
│   ├── package.json                    
│   ├── README.md
│   └── run.js                          # node.js cloudstack client
└── LICENSE
```
# Man Page
```
$ ./cloudstackHosts.sh --help
Use: ./cloudstackHosts.sh [command ...]

     commands
     help - show this help
     get  - get a cloudstack hosts list - ~/.coudhosts
     sync - merge cloudstack hosts in hosts file - use sudo to sync
     show - show hosts in cache

```
* *HELP* - show the help messages.
* *GET*  - get a apache-cloudstack hosts list.
>>the list is save in *~/.coudhosts* file
* *SYNC* -merge apache-cloudstack hosts list with a local hosts file.
>>if you execute this option with a *sudo* the original file iw changed and a backup file is save in *~/.hosts.old*
* *SHOW* - show hosts in cache getted in apache-cloudstack
