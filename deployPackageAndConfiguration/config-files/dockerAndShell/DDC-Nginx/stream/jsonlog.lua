local cjson = require('cjson')
local log = {}

log.local_time = ngx.localtime()
log.trace_id = ngx.var.trace_id
log.request_method = ngx.var.request_method
log.http_host = ngx.var.host
log.request_uri = ngx.var.request_uri
log.request_length = tonumber(ngx.var.request_length)
log.request_body = ngx.var.request_body and cjson.encode(ngx.var.request_body)  or ""
log.upstream_addr = ngx.var.upstream_addr
log.upstream_response_time = tonumber(ngx.var.upstream_response_time)
log.upstream_status = tonumber(ngx.var.upstream_status)
log.bytes_sent = tonumber(ngx.var.bytes_sent)
log.status = tonumber(ngx.var.status)
log.request_time = tonumber(ngx.var.request_time)
log.remote_addr = ngx.var.remote_addr
log.server_addr = ngx.var.server_addr
log.http_referer = ngx.var.http_referer or ""
log.http_x_forwarded_for = ngx.var.http_x_forwarded_for or ""
log.http_user_agent = ngx.var.http_user_agent
log.http_apitoken = ngx.var.http_apitoken
--[[
log.model = ""
log.system = ""
log.version = ""
log.brand = ""
log.platform = ""
log.screenWidth = ""
log.screenHeight = ""
log.pixelRatio = ""
log.SDKVersion = ""
if ngx.var.http_x_system_info then
   local  system_info = cjson.decode(ngx.var.http_x_system_info)
    if system_info then
        log.model = system_info.model
        log.system = system_info.system
        log.version = system_info.version
        log.brand = system_info.brand
        log.platform = system_info.platform
        log.screenWidth = system_info.screenWidth
        log.screenHeight = system_info.screenHeight
        log.pixelRatio = system_info.pixelRatio
        log.SDKVersion = system_info.SDKVersion
    end
end
]]
 
local jsonlog = cjson.encode(log)
ngx.var.jsonlog = jsonlog

