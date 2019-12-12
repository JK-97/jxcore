// Copyright © 2018 NAME HERE <EMAIL ADDRESS>
// Copyright © 2018 NAME HERE <EMAIL ADDRESS>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"jxcore/core/device"
	"jxcore/core/register"
	"jxcore/lowapi/docker"
	log "jxcore/lowapi/logger"
	"net/url"
	"os"
	"os/exec"

	"github.com/spf13/cobra"
)

var (
	vpnmode string

	ticket string

	authHost string

	install bool
)

const (
	restoreImagePath     = "/restore/dockerimage"
	restoreBootstrapPath = "/jxbootstrap"
)

/******
bootstrap -s :
	跳过安装步骤只进行注册

bootstrap ：
	只进行安装，和生成设备的workerid，不进行注册，设备连接不上云，需要使用注册机


******/

// bootstrapCmd represents the bootstrap command
var bootstrapCmd = &cobra.Command{
	Use:   "bootstrap",
	Short: "bootstrap http backend for jxcore",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,

	Run: func(cmd *cobra.Command, args []string) {
		defer func() {
			if err := recover(); err != nil {
				log.Error(err)
			}
		}()

		if len(ticket) < 2 {
			panic(errors.New("Tickit Error"))
		}
		err := syncVersion()
		if err != nil {
			panic(err)
		}

		currentDevice, err := device.GetDevice()
		if err != nil {
			panic(err)
		}

		workerID, err := device.BuildWokerID()
		if err != nil {
			panic(errors.New("Build WokerID Failed"))
		}
		fmt.Println("WorkerID : ", workerID)

		err = currentDevice.SetHostname(workerID)
		if err != nil {
			panic(errors.New("Set Hostname Failed"))
		}

		currentDevice.WorkerID = workerID
		err = currentDevice.UpdateDeviceInfo()
		if err != nil {
			panic(err)
		}

		if !install {
			err := currentDevice.BuildDeviceInfo(device.Vpn(vpnmode), ticket, authHost)
			if err != nil {
				panic(err)
			}

			fmt.Println("KEY      : ", currentDevice.Key)
			fmt.Println("DHCP     : ", currentDevice.DhcpServer)
			fmt.Println("VPN      : ", currentDevice.Vpn)

		} else {

			// docker images恢复
			fmt.Println("尝试恢复本地镜像")
			loadDockerImage()
			//执行安装脚本
			fmt.Println("执行安装脚本")
			err := runBootstrapScript()
			if err != nil {
				panic(err)
			}

		}

	},
}

// GetHost 从 url 中解析 Host
func GetHost(u string) string {
	uri, err := url.Parse(u)
	if err != nil {
		return u
	}
	return uri.Hostname()
}

func init() {
	rootCmd.AddCommand(bootstrapCmd)
	bootstrapCmd.PersistentFlags().StringVarP(&vpnmode, "mode", "m", device.VPNModeRandom.String(), "openvpn or wireguard or local")
	bootstrapCmd.PersistentFlags().StringVarP(&ticket, "ticket", "t", "", "ticket for bootstrap")
	bootstrapCmd.PersistentFlags().StringVarP(&authHost, "host", "", register.FallBackAuthHost, "host for bootstrap")
	bootstrapCmd.PersistentFlags().BoolVarP(&install, "skip", "i", false, "skip restore")

}

// LoadDockerImage载入镜像
func loadDockerImage() {
	if _, err := os.Stat(restoreImagePath); err == nil {
		log.Info("Restore Docker Images")
		var dockerobj = docker.NewClient()
		err := dockerobj.DockerRestore()
		if err != nil {
			log.Error(err)
		} else {
			log.Info("Finish Restore Docker Images")
		}
	}
}

// runBootstrapScript 运行安装脚本
func runBootstrapScript() error {
	if _, err := os.Stat(restoreBootstrapPath); err == nil {
		basecmd := exec.Command("/jxbootstrap/worker/scripts/base.sh")
		basecmd.Stdout = os.Stdout
		basecmd.Stdout = os.Stderr
		err = basecmd.Run()
		if err != nil {
			return err
		}
	}
	return nil
}

// syncVersion 同步target 与当前安装的版本
func syncVersion() error {
	rawdata, err := ioutil.ReadFile(CurrentVersionFile)
	if err != nil {
		return err
	}
	var currentversion = map[string]string{
		"jx-toolset": string(rawdata),
	}
	out, err := json.MarshalIndent(currentversion, "", "  ")
	if err != nil {
		return err
	}
	err = ioutil.WriteFile(TargetVersionFile, out, 0666)
	if err != nil {
		return err
	}
	return nil

}
