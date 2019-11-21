package device

import (
	"bytes"
	"crypto/md5"
	"encoding/json"
	"fmt"
	log "gitlab.jiangxingai.com/applications/base-modules/internal-sdk/go-utils/logger"
	"io/ioutil"
	"jxcore/lowapi/utils"
	"jxcore/version"
	"math/rand"
	"net/http"
	"os/exec"
	"runtime"
	"strings"
	"time"

	"gopkg.in/yaml.v2"
)

const (
	initPath    = "/edge/init"
	cpuInfoFile = "/proc/cpuinfo"
)

var device *Device

func GetDeviceType() (devicetype string) {
	return version.Type
}

func getDevice() error {
	readdata, err := ioutil.ReadFile(initPath)
	if err != nil {
		return err
	}
	return yaml.Unmarshal(readdata, &device)
}

// GetDevice 获取节点信息，从/edge/init读取一次后存入cache
func GetDevice() (*Device, error) {
	var err error
	if device == nil {
		err = getDevice()
	}
	return device, err
}

// BuildWokerID 生成wokerid
func BuildWokerID() string {
	perfilx := "J"
	if runtime.GOARCH == "amd64" {
		perfilx = perfilx + "02"
	} else {
		perfilx = perfilx + "01"
	}

	var GpsInfoScript string = "python /jxbootstrap/worker/scripts/G8100_NoMCU.py CMD AT+CGSN"
	var md5info [16]byte
	// x86平台
	if runtime.GOARCH == "amd64" {
		var X86IdInfoScript string = "dmidecode | grep 'Serial Number' | head -1 | awk -F\":\" '{gsub(\" ^ \", \"\", $2); print $2}'"
		context, err := exec.Command("/bin/bash", "-c", X86IdInfoScript).Output()
		if err != nil {
			log.Error(err)
		}
		md5info = md5.Sum([]byte(context))

	} else {
		content, err := ioutil.ReadFile(cpuInfoFile)
		utils.CheckErr(err)

		if strings.Contains(string(content), "Serial") {
			// RK品台
			md5info = md5.Sum(content[len(string(content))-17:])
		} else {
			for index := 0; index < 10; index++ {
				//小概率会获得空的数据,需重试
				gpsInfo, err := exec.Command("/bin/sh", "-c", GpsInfoScript).Output()
				utils.CheckErr(err)
				result := strings.ReplaceAll(string(gpsInfo), "\n", "")
				result = strings.TrimSpace(result)
				if len(result) > 10 {
					md5info = md5.Sum([]byte(result))
					break
				}

			}
		}
	}

	md5str := fmt.Sprintf("%x", md5info)
	if md5str == "0000000" {
		panic("can't generate workerid'")
	}
	workerid := perfilx + md5str[len(md5str)-7:]
	return workerid
}

// BuildDeviceInfo
func (d *Device) BuildDeviceInfo(vpnmodel Vpn, ticket string, authHost string) {
	if d == nil {
		d = new(Device)
	}
	if d.WorkerID == "" {
		d.WorkerID = BuildWokerID()
	}
	if vpnmodel == VPNModeRandom {
		r := rand.New(rand.NewSource(time.Now().Unix()))
		vpnmodel = vpnSlice[r.Intn(len(vpnSlice))]
	}

	if GetDeviceType() == version.Pro {
		//pro
		//有dhcpserver则不再变动
		if d.DhcpServer != "" {
			d.DhcpServer = authHost
		} else {
			switch vpnmodel {
			case VPNModeLocal:
				d.DhcpServer = VPNModeLocal.String()
			case VPNModeWG, VPNModeOPENVPN, VPNModeRandom:
				d.DhcpServer = authHost
			default:
				log.Fatal("err vpnmodel")
			}
		}

		reqinfo := buildkeyreq{Workerid: d.WorkerID, Ticket: ticket}
		data, err := json.Marshal(reqinfo)
		if err != nil {
			log.Error(err)
		}
		//通过域名获取key
		body := bytes.NewBuffer(data)
		log.Info("Post to ", d.DhcpServer+BOOTSTRAPATH)

		// http.DefaultClient.Timeout = 8 * time.Second
		resp, err := http.Post(d.DhcpServer+BOOTSTRAPATH, "application/json", body)
		if err != nil {
			log.Error(err)
			return
		}
		log.Info("Status:", resp.Status)
		respdata, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			log.Error(err)
		}
		respinfo := buildkeyresp{}
		json.Unmarshal(respdata, &respinfo)
		d.Key = respinfo.Data.Key
		d.Vpn = vpnmodel
		log.Info("Completed")
	} else {
		//base
		if vpnmodel != VPNModeLocal || authHost != VPNModeLocal.String() {
			log.Fatal("Base version can not support networking")
		}
		d.Vpn = VPNModeLocal
		d.DhcpServer = VPNModeLocal.String()

	}
	log.Info("Update Init Config File")
	outputdata, err := yaml.Marshal(d)
	utils.CheckErr(err)
	ioutil.WriteFile("/edge/init", outputdata, 0666)

}
func IfRunMcu() bool {
	content, err := ioutil.ReadFile(cpuInfoFile)
	utils.CheckErr(err)
	if strings.Contains(string(content), "Serial") {
		// rk
		return true
	} else if runtime.GOARCH == "amd64" || !strings.Contains(string(content), "Serial") {
		// nano 或则 x86 没有mcu
		return false
	} else {
		return true
	}
}
