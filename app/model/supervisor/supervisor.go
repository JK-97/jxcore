package supervisor

import (
	"bytes"
	"io"
	"io/ioutil"
	"log"
	// "net"
	"net"
	"net/http"
	"net/url"
	// "strings"

	"github.com/lrh3321/gorilla-xmlrpc/xml"
)

var supervisorMethodNames = []string{
	"supervisor.addProcessGroup",
	"supervisor.clearAllProcessLogs",
	"supervisor.clearLog",
	"supervisor.clearProcessLog",
	"supervisor.clearProcessLogs",
	"supervisor.getAPIVersion",
	"supervisor.getAllConfigInfo",
	"supervisor.getAllProcessInfo",
	"supervisor.getIdentification",
	"supervisor.getPID",
	"supervisor.getProcessInfo",
	"supervisor.getState",
	"supervisor.getSupervisorVersion",
	"supervisor.getVersion",
	"supervisor.readLog",
	"supervisor.readMainLog",
	"supervisor.readProcessLog",
	"supervisor.readProcessStderrLog",
	"supervisor.readProcessStdoutLog",
	"supervisor.reloadConfig",
	"supervisor.removeProcessGroup",
	"supervisor.restart",
	"supervisor.sendProcessStdin",
	"supervisor.sendRemoteCommEvent",
	"supervisor.shutdown",
	"supervisor.signalAllProcesses",
	"supervisor.signalProcess",
	"supervisor.signalProcessGroup",
	"supervisor.startAllProcesses",
	"supervisor.startProcess",
	"supervisor.startProcessGroup",
	"supervisor.stopAllProcesses",
	"supervisor.stopProcess",
	"supervisor.stopProcessGroup",
	"supervisor.tailProcessLog",
	"supervisor.tailProcessStderrLog",
	"supervisor.tailProcessStdoutLog",
	// "system.listMethods",
	// "system.methodHelp",
	// "system.methodSignature",
	// "system.multicall",
}

// SupervisorRPC SupervisorRPC
type SupervisorRPC struct {
	client *http.Client
}

// NewSupervisorRPC 返回 SupervisorRPC 实例
func NewSupervisorRPC(addr string) *SupervisorRPC {

	u, err := url.Parse(addr)

	if err != nil {
		return nil
	}
	var client *http.Client
	if u.Scheme == "unix" {
		client = &http.Client{
			Transport: &http.Transport{
				Dial: func(network, addr string) (net.Conn, error) {
					return net.Dial("unix", u.Path)
				},
			},
		}
	} else {
		client = &http.Client{
			Transport: &http.Transport{
				Dial: func(network, addr string) (net.Conn, error) {
					return net.Dial("tcp", u.Host)
				},
			},
		}
	}

	return &SupervisorRPC{client: client}
}

type emptyArg struct {
}

var empty = new(emptyArg)

type arg1 struct {
	Arg interface{}
}

// ProcessInfo Get info about a process named name
type ProcessInfo struct {
	Name          string `json:"name" xml:"name"`
	Group         string `json:"group" xml:"group"`
	Description   string `json:"description" xml:"description"`
	Start         int    `json:"start" xml:"start"`
	Stop          int    `json:"stop" xml:"stop"`
	Now           int    `json:"now" xml:"now"`
	State         int    `json:"state" xml:"state"`
	Statename     string `json:"statename" xml:"statename"`
	Spawnerr      string `json:"spawnerr" xml:"spawnerr"`
	Exitstatus    int    `json:"exitstatus" xml:"exitstatus"`
	Logfile       string `json:"logfile" xml:"logfile"`
	StdoutLogfile string `json:"stdout_logfile" xml:"stdout_logfile"`
	StderrLogfile string `json:"stderr_logfile" xml:"stderr_logfile"`
	Pid           int    `json:"pid" xml:"pid"`
}

// ProcessInfoResult ProcessInfoResult
type ProcessInfoResult struct {
	Process ProcessInfo
}

// AllProcessInfoResult ProcessInfoResult
type AllProcessInfoResult struct {
	Processes []ProcessInfo
}

func (r *SupervisorRPC) invokeXMLRPC(body io.Reader) (buffer *bytes.Buffer, err error) {
	resp, err := r.client.Post("http://fakehost/RPC2", "text/xml", body)
	if err != nil {
		return
	}
	defer resp.Body.Close()

	buf, _ := ioutil.ReadAll(resp.Body)

	buffer = bytes.NewBuffer(buf)

	// log.Println(buffer.String())
	return
}

// GetIdentification Return identifying string of supervisord
func (r *SupervisorRPC) GetIdentification() (result string, err error) {
	method := "supervisor.getIdentification"

	buf, _ := xml.EncodeClientRequest(method, empty)

	buffer, err := r.invokeXMLRPC(bytes.NewBuffer(buf))
	if err != nil {
		return
	}

	reply := struct{ Result string }{}

	err = xml.DecodeClientResponse(buffer, &reply)
	result = reply.Result

	return
}

func readAllProcessInfo(r io.Reader) (result []ProcessInfo, err error) {
	reply := AllProcessInfoResult{}
	err = xml.DecodeClientResponse(r, &reply)
	result = reply.Processes
	return
}

// StartAllProcesses Start all processes listed in the configuration file
// @param boolean wait Wait for each process to be fully started
// @return array result An array of process status info structs
func (r *SupervisorRPC) StartAllProcesses(wait bool) (result []ProcessInfo, err error) {
	method := "supervisor.startAllProcesses"

	buf, _ := xml.EncodeClientRequest(method, &arg1{wait})

	buffer, err := r.invokeXMLRPC(bytes.NewBuffer(buf))
	if err != nil {
		return
	}

	result, err = readAllProcessInfo(buffer)
	return
}

// StopAllProcesses Stop all processes in the process list
// @param boolean wait Wait for each process to be fully stopped
// @return array result An array of process status info structs
func (r *SupervisorRPC) StopAllProcesses(wait bool) (result []ProcessInfo, err error) {
	method := "supervisor.stopAllProcesses"

	buf, _ := xml.EncodeClientRequest(method, &arg1{wait})

	buffer, err := r.invokeXMLRPC(bytes.NewBuffer(buf))
	if err != nil {
		return
	}

	result, err = readAllProcessInfo(buffer)
	return
}

// GetAllProcessInfo Get info about all processes
func (r *SupervisorRPC) GetAllProcessInfo() (result []ProcessInfo, err error) {
	method := "supervisor.getAllProcessInfo"

	buf, _ := xml.EncodeClientRequest(method, empty)

	buffer, err := r.invokeXMLRPC(bytes.NewBuffer(buf))
	if err != nil {
		return
	}

	result, err = readAllProcessInfo(buffer)
	return
}

// GetProcessInfo Get info about a process named name
func (r *SupervisorRPC) GetProcessInfo(name string) (result ProcessInfo, err error) {
	method := "supervisor.getProcessInfo"

	buf, _ := xml.EncodeClientRequest(method, &arg1{name})

	buffer, err := r.invokeXMLRPC(bytes.NewBuffer(buf))
	if err != nil {
		return
	}

	reply := ProcessInfoResult{}
	err = xml.DecodeClientResponse(buffer, &reply)
	result = reply.Process
	return
}

// ReloadConfig Reload the configuration.
// The result contains three arrays containing names of process groups:
// added gives the process groups that have been added
// changed gives the process groups whose contents have changed
// removed gives the process groups that are no longer in the configuration
// @return array result [[added, changed, removed]]
func (r *SupervisorRPC) ReloadConfig() (result ProcessInfo, err error) {
	method := "supervisor.reloadConfig"

	buf, _ := xml.EncodeClientRequest(method, empty)

	buffer, err := r.invokeXMLRPC(bytes.NewBuffer(buf))
	if err != nil {
		return
	}
	log.Println(buffer.String())
	// reply := ProcessInfoResult{}
	// err = xml.DecodeClientResponse(buffer, &reply)
	// result = reply.Process
	return
}

//StopProcess :Stop a process named by name
//@param string name The name of the process to stop (or ‘group:name’)
//@param boolean wait Wait for the process to be fully stopped
//@return boolean result Always return True unless error
func (r *SupervisorRPC) StopProcess(name string) (result bool, err error) {
	method := "supervisor.stopProcess"
	buf, _ := xml.EncodeClientRequest(method, &arg1{name})
	buffer, err := r.invokeXMLRPC(bytes.NewBuffer(buf))
	if err != nil {
		return
	}
	reply := struct{ Result bool }{}
	err = xml.DecodeClientResponse(buffer, &reply)
	result = reply.Result
	return

}

//StartProcess Start a process
//@param string name Process name (or group:name, or group:*)
// @param boolean wait Wait for process to be fully started @return boolean result Always true unless error
func (r *SupervisorRPC) StartProcess(name string) (result bool, err error) {
	method := "supervisor.startProcess"
	buf, _ := xml.EncodeClientRequest(method, &arg1{name})
	buffer, err := r.invokeXMLRPC(bytes.NewBuffer(buf))
	if err != nil {
		return
	}
	reply := struct{ Result bool }{}
	err = xml.DecodeClientResponse(buffer, &reply)
	result = reply.Result
	return

}
