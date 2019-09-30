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
    "io/ioutil"
    "jxcore/config"
    "jxcore/core/device"
    "jxcore/journal"
    "jxcore/log"
    "jxcore/management/updateM"
    "jxcore/systemapi/network"
    "jxcore/systemapi/utils"
    "jxcore/web/route"
    "net/http"
    "os"
    "os/exec"
    "os/signal"
    "syscall"
    "time"

    // 调试
    _ "net/http/pprof"

    // 日志采插件
    _ "jxcore/journal/docker"
    _ "jxcore/journal/rfile"
    _ "jxcore/journal/systemd"

    "github.com/spf13/cobra"
)

const (
    InitPath = "/edge/init"
    logBase  = "/edge/logs/"
)

var start chan bool

// serveCmd represents the serve command
var serveCmd = &cobra.Command{
    Use:   "serve",
    Short: "Serve http backend for jxcore",
    Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
    Run: func(cmd *cobra.Command, args []string) {
        forever := make(chan interface{}, 1)
        signalChannel := make(chan os.Signal, 16)
        signal.Notify(signalChannel)
        go handleSignal(signalChannel, forever)


        if utils.Exists(InitPath) {
            
        } else {
            log.Fatal("please run the bootstrap before serve")
        }
        currentdevice,err := device.GetDevice()
        utils.CheckErr(err)
        if network.CheckNetwork() {
            updateprocess := updateM.GetUpdateProcess()
            updateprocess.UploadVersion()
            pkgneedupdate := updateprocess.CheckUpdate()
            if len(pkgneedupdate) != 0 {
                updateprocess.UpdateSource()
                updateprocess.UpdateComponent(pkgneedupdate)
                log.Info("updating")
            }
            for {
                if updateprocess.GetStatus() == updateM.FINISHED {
                    break
                }
            }
            updateprocess.UploadVersion()
        } else {
            log.Warn("The network is not working properly and automatically enters offline mode.")
        }


        // 启动 DNS 修改(离线、在线)
        // 启动基础服务: DB/rabbitmq/consul/influxdb(离线、在线)
        // 启动 gateway (离线、在线)
        // 启动 component 按照配置启动(tools, fileslistener)




        // (pro版本, jxcore hardcode) 启动 VPN, 离线模式下一直重试
        // pro板 需要检查 同步工具完整性(按照启动的配置)
        // VPN 就绪之后 启动 component 按照配置启动(同步工具集合)




        log.Info("Prepare to collect journal")
        go collectJournal(currentdevice.WorkID)


        port, err := cmd.Flags().GetString("port")
        if err != nil {
            port = ":80"
        }
        go func() {
            log.Info("Listen on", port)
            log.Fatal(http.ListenAndServe(port, route.Routes()))
            os.Exit(1)
            forever <- nil
        }()

        <-forever
    },
}

func init() {
    rootCmd.AddCommand(serveCmd)
    cmd := exec.Command("/bin/bash", "-c", "pgrep gateway | xargs kill -s 9")
    cmd.Run()

    // Here you will define your flags and configuration settings.

    // Cobra supports Persistent Flags which will work for this command
    // and all subcommands, e.g.:
    serveCmd.PersistentFlags().String("port", ":80", "Port to run Application server on")
    serveCmd.PersistentFlags().String("interface", "eth0", "gateway listen where")
    serveCmd.PersistentFlags().String("config", "./settings.yaml", "yaml setting for component")
    serveCmd.PersistentFlags().Bool("debug", false, "Whether to enable pprof")
    cfg := config.Config()
    cfg.BindPFlag("yamlsettings", serveCmd.PersistentFlags().Lookup("config"))
    cfg.BindPFlag("interface", serveCmd.PersistentFlags().Lookup("interface"))
    // Cobra supports local flags which will only run when this command
    // is called directly, e.g.:
    // serveCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

// applySyncTools 配置同步工具
func applySyncTools() {
    if utils.Exists("/edge/synctools.zip") {
        data, err := ioutil.ReadFile("/edge/synctools.zip")
        if err != nil {
            log.Error(err)
        } else {
            err = utils.Unzip(data, "/edge/mnt")
            if err == nil {
                log.Info("has find the synctools.zip")
                os.Remove("/edge/synctools.zip.old")
                if err = os.Rename("/edge/synctools.zip", "/edge/synctools.zip.old"); err != nil {
                    log.Error("Fail to move /edge/synctools.zip to /edge/synctools.zip.old", err)
                }
            }
        }
    }
}

func collectJournal(workerID string) {

    ttl := time.Hour * 24 * 30 // 日志只保留 30 天
    journalConfig := map[string]interface{}{
        "rotate-directory": []string{logBase},
    }

    arcFolder := "/data/edgebox/local/logs"
    metaFolder := "/data/edgebox/remote/logs/" + workerID

    os.MkdirAll(arcFolder, 0755)
    os.MkdirAll(metaFolder, 0755)

    journal.RunForever(&journalConfig, 20*time.Minute, arcFolder, metaFolder, ttl)
}

func handleSignal(c <-chan os.Signal, w chan<- interface{}) {
    for sig := range c {
        log.Info("Receive Signal", sig)
        switch sig {
        case syscall.SIGKILL, syscall.SIGABRT, syscall.SIGTERM, syscall.SIGHUP, syscall.SIGINT, syscall.SIGQUIT:
            os.Exit(1)
            w <- sig
        case syscall.SIGPIPE, SIGCHLD, SIGTSTP, SIGCONT:
        }
    }
}

// 信号
var (
    SIGCHLD os.Signal = syscall.Signal(0x11)
    SIGTSTP os.Signal = syscall.Signal(0x14)
    SIGCONT os.Signal = syscall.Signal(0x12)
)
