package dns

const (
	LocalHostName   = "edgegw.localhost"
	IotedgeHostName = "edgegw.iotedge"
	MasterHostName  = "master.iotedge"

	consulConfigPath = "/data/edgex/consul/config/consul_conf.json"

	HostsFile  = "/etc/dnsmasq.hosts"
	resolvPath = "/etc/resolv.conf"

	dnsmasqConfPath       = "/etc/dnsmasq.conf"
	dnsmasqResolvPath     = "/etc/dnsmasq.resolv.conf"
	ifaceResolvPathPrefix = "/edge/resolv.d/dhclient."

	dhcpEnterHooksDir      = "/etc/dhcp/dhclient-enter-hooks.d"
	dhclientResolvHookPath = dhcpEnterHooksDir + "/nodnsupdate"

	ifacePath = "/etc/network/interfaces"

	DnsmasqListenIP = "172.18.1.1"
)

// 全局变量
var (
	FixedResolver = "" // 指定的固定 dns
)

const ifaceDNSConfHeader = `################ DHCP Nameserver #############################################
################ Below is the nameserver obtained by dhclient ################
################ Maintained by Jxcore, don't modify!! ########################
`