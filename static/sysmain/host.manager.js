/**
 * Created by liulixiang on 2017/9/13.
 */


$(document).ready(function() {

        $("#submitBtn").click(function () {
            var hostname = $("#hostname").val().trim()
            var ipaddr = $("#ipaddr").val().trim()
            var sshport = $("#sshport").val().trim()
            var username = $("#username").val().trim()
            var password = $("#password").val().trim()
            var result = ""
            result += hostname ? showAlertMsg("show-host-msg","",false) : showAlertMsg("show-host-msg","主机名称不能为空！",true)
            result += username ? showAlertMsg("show-username-msg","",false) : showAlertMsg("show-username-msg","用户名不能为空！",true)
            result += password ? showAlertMsg("show-passwd-msg","",false) : showAlertMsg("show-passwd-msg","密码不能为空！",true)
            result += isValidIPAddr(ipaddr) ? showAlertMsg("show-ipaddr-msg","",false) : showAlertMsg("show-ipaddr-msg","请输入有效的IP地址！",true)
            result += isValidHostPort(sshport) ? showAlertMsg("show-sshport-msg","",false) : showAlertMsg("show-sshport-msg","请输入有效的端口号!",true)

            if(!isContains(result.toString(),"false")){
                $.post("/host/add/",$("#hostaddform").serialize(),function(result){
                     if(result.indexOf("Error:") >= 0) {
                         $("#show-result-msg").addClass("alert alert-error").html(result);
                     } else {
                         window.location.href = result
                     }
                })
            }
        });


    });






//显示警告信息
function showAlertMsg(id,msg,type){
   if(type){
       $("#" + id).addClass("alert alert-error").html(msg);
       return false;
   } else {
       $("#" + id).removeClass("alert alert-error").html("");
       return true;
   }
}

//验证某个字符串是否包含另一字符串
function isContains(str,substr) {
    return new RegExp(substr).test(str);
}

// 验证IP地址
function isValidIPAddr(ip) {
    var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
    return reg.test(ip);
}

//验证是否是数字
function  isValidNumber(num) {
    var reg = /^[0-9]*$/
    return reg.test(num)
}

//验证服务端口号
function isValidHostPort(port) {
    var reg = /^([0-9]|[1-9]\d{1,3}|[1-5]\d{4}|6[0-5]{2}[0-3][0-5])$/
    return reg.test(port)
}

//验证手机号码
function isValidMobileNumber(tel) {
    var reg = /^1(3|4|5|7|8)\d{9}$/
    return reg.test(tel)
}