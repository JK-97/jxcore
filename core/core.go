package core

import (
	"context"
	"github.com/JK-97/edge-guard/config/yaml"
	"github.com/JK-97/edge-guard/core/register"
	"github.com/JK-97/edge-guard/internal/network/dns"
	"github.com/JK-97/edge-guard/internal/network/iface"
	"github.com/JK-97/edge-guard/management/updatemanage"

	"golang.org/x/sync/errgroup"
)

func ConfigSupervisor() {
	startupProgram := yaml.Config
	yaml.ParseAndCheck(*startupProgram, "")
}

func MaintainNetwork(ctx context.Context, noUpdate bool) error {
	dns.TrySetupDnsConfig()

	errGroup := errgroup.Group{}

	// 按优先级切换网口
	// fist should be true connection between local and dhcpserver
	errGroup.Go(func() error { return iface.MaintainBestIFace(ctx) })

	// 第一次连接master成功，检查固件更新
	onFirstConnect := func() {
		manager := updatemanage.NewUpdateManager()
		manager.ReportVersion()
		if !noUpdate {
			manager.Start()
		}
	}
	// second should be true connection between local and master
	errGroup.Go(func() error { return register.MaintainMasterConnection(ctx, onFirstConnect) })

	return errGroup.Wait()
}
