package dnsdetector

import (
	"github.com/rjeczalik/notify"
	log "gitlab.jiangxingai.com/applications/base-modules/internal-sdk/go-utils/logger"
	"jxcore/lowapi/dns"
)

// DnsDetector 检测 resolv 文件的改动
func DnsDetector() error {
	c := make(chan notify.EventInfo, 2)
	if err := notify.Watch(dns.ResolvFile, c, notify.Remove); err != nil {
		log.Error(err)
	}
	for ei := range c {
		switch ei.Event() {
		case notify.Remove:
			dns.ResolvGuard()
			notify.Stop(c)
			DnsDetector()
		}
	}
	return nil
}
