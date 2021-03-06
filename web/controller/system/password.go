package system

import (
	"fmt"
	"net/http"

	"github.com/JK-97/edge-guard/lowapi/store/filestore"
	"github.com/JK-97/edge-guard/oplog"
	"github.com/JK-97/edge-guard/oplog/logs"
	"github.com/JK-97/edge-guard/oplog/types"
	"github.com/JK-97/edge-guard/web/controller/utils"
)

type SetPasswordRequest struct {
	OldPassword string `json:"old_password"`
	NewPassword string `json:"new_password"`
}

const (
	passwordKey     = "password"
	defaultPassword = ""
)

// 设置edge-guard密码
func SetPasswordHandler(w http.ResponseWriter, r *http.Request) {
	request := SetPasswordRequest{}
	utils.MustUnmarshalJson(r.Body, &request)

	oldPassword, err := getPassword()
	if err != nil {
		panic(err)
	}
	if oldPassword != request.OldPassword {
		panic(utils.HTTPError{
			Code: http.StatusBadRequest,
			Err:  fmt.Errorf("old password incorrect."),
		})
	}

	err = filestore.KV.Set(passwordKey, []byte(request.NewPassword))
	if err != nil {
		panic(err)
	}
	oplog.Insert(logs.NewOplog(types.AUTH, "change passwd"))
	utils.RespondSuccessJSON(nil, w)
}

func getPassword() (string, error) {
	data, err := filestore.KV.GetDefault(passwordKey, []byte(defaultPassword))
	return string(data), err
}
