--[[

    SWUpdate Suricatta Lua Module.

    Interface specification for the Lua module provided by the
    "Suricatta Lua module" suricatta "server" (suricatta/server_lua.c).

    Author: Christian Storm <christian.storm@siemens.com>
    Copyright (C) 2022, Siemens AG

    SPDX-License-Identifier: GPL-2.0-or-later

--]]

---@diagnostic disable: unused-local
-- luacheck: no max line length
-- luacheck: no unused args

local suricatta = {}


--- Lua equivalent of `server_op_res_t` enum as in `include/util.h`.
--
--- @class suricatta.status
--- @type  table<string, number>
suricatta.status = {
    OK                  = 0,
    EERR                = 1,
    EBADMSG             = 2,
    EINIT               = 3,
    EACCES              = 4,
    EAGAIN              = 5,
    UPDATE_AVAILABLE    = 6,
    NO_UPDATE_AVAILABLE = 7,
    UPDATE_CANCELED     = 8,
    ID_REQUESTED        = 9,
}


--- SWUpdate notify function bindings.
--
-- Translates to `notify(string.format(message, ...))`, see
-- `corelib/lua_interface.c`.
--
--- @type table<string, function>
suricatta.notify = {
    --- @type fun(message: string, ...: any)
    error    = function(message, ...) end,
    --- @type fun(message: string, ...: any)
    trace    = function(message, ...) end,
    --- @type fun(message: string, ...: any)
    debug    = function(message, ...) end,
    --- @type fun(message: string, ...: any)
    info     = function(message, ...) end,
    --- @type fun(message: string, ...: any)
    warn     = function(message, ...) end,
    --- @type fun(message: string, ...: any)
    progress = function(message, ...) end,
}


--- SWUpdate's persistent state IDs as in `include/state.h` and reverse-lookup.
--
--- @class suricatta.pstate
suricatta.pstate = {
    OK            = string.byte('0'), [string.byte('0')] = "OK",
    INSTALLED     = string.byte('1'), [string.byte('1')] = "INSTALLED",
    TESTING       = string.byte('2'), [string.byte('2')] = "TESTING",
    FAILED        = string.byte('3'), [string.byte('3')] = "FAILED",
    NOT_AVAILABLE = string.byte('4'), [string.byte('4')] = "NOT_AVAILABLE",
    ERROR         = string.byte('5'), [string.byte('5')] = "ERROR",
    WAIT          = string.byte('6'), [string.byte('6')] = "WAIT",
    IN_PROGRESS   = string.byte('7'), [string.byte('7')] = "IN_PROGRESS",

    --- Get the current stored persistent state.
    --
    --- @return boolean           # Whether operation was successful or not
    --- @return suricatta.pstate  # Persistent state ID number
    get = function() end,

    --- Save persistent state information.
    --
    --- @param  state  suricatta.pstate  Persistent state ID number
    --- @return boolean                  # Whether operation was successful or not
    save = function(state) end,
}


--- Function registry IDs for Lua suricatta functions.
--
--- @class suricatta.server
suricatta.server = {
    HAS_PENDING_ACTION    = 0,
    INSTALL_UPDATE        = 1,
    SEND_TARGET_DATA      = 2,
    GET_POLLING_INTERVAL  = 3,
    SERVER_START          = 4,
    SERVER_STOP           = 5,
    IPC                   = 6,
    PRINT_HELP            = 7,
    CALLBACK_PROGRESS     = 8,
    CALLBACK_CHECK_CANCEL = 9,

    --- Register a Lua function as Suricatta interface implementation.
    --
    --- @param  function_p  function          Function to register for `purpose`
    --- @param  purpose     suricatta.server  Suricatta interface function implemented
    --- @return boolean                       # Whether operation was successful or not
    register = function(function_p, purpose) end,
}


suricatta.channel = {
    --- Content type passed over the channel as in `include/channel_curl.h`.
    --
    --- @class suricatta.channel.content
    --- @type  table<string, number>
    content = {
        NONE = 0,
        JSON = 1,
        RAW  = 2,
    },

    --- Transfer method to use over channel as in `include/channel_curl.h`.
    --
    --- @class suricatta.channel.method
    --- @type  table<string, number>
    method = {
        GET   = 0,
        POST  = 1,
        PUT   = 2,
        PATCH = 3,
    },

    --- Channel options as in `include/channel_curl.h`.
    --
    --- @class suricatta.channel.options
    --- @field url                 string   `CURLOPT_URL` - URL for this transfer
    --- @field cached_file         string   Resume download from cached file at path
    --- @field auth                string   `CURLOPT_USERPWD` - user name and password to use in authentication
    --- @field request_body        string   Data to send to server for `PUT` and `POST`
    --- @field iface               string   `CURLOPT_INTERFACE` - source interface for outgoing traffic
    --- @field dry_run             boolean  `swupdate_request`'s dry_run field as in `include/network_ipc.h`
    --- @field cafile              string   `CURLOPT_CAINFO` - path to Certificate Authority (CA) bundle
    --- @field sslkey              string   `CURLOPT_SSLKEY` - private key file for TLS and SSL client cert
    --- @field sslcert             string   `CURLOPT_SSLCERT` - SSL client certificate
    --- @field ciphers             string   `CURLOPT_SSL_CIPHER_LIST` - ciphers to use for TLS
    --- @field proxy               string   `CURLOPT_PROXY` - proxy to use
    --- @field info                string   `swupdate_request`'s info field as in `include/network_ipc.h`
    --- @field auth_token          string   String appended to Header
    --- @field content_type        string   `Content-Type:` and `Accept:` appended to Header
    --- @field retry_sleep         number   Time to wait prior to retry and resume a download
    --- @field method              suricatta.channel.method  Channel transfer method to use
    --- @field retries             number   Maximal download attempt count
    --- @field low_speed_timeout   number   `CURLOPT_LOW_SPEED_TIME` - low speed limit time period
    --- @field connection_timeout  number   `CURLOPT_CONNECTTIMEOUT` - timeout for the connect phase
    --- @field format              suricatta.channel.content  Content type passed over the channel
    --- @field debug               boolean  Set channel debug logging
    --- @field usessl              boolean  Enable SSL hash sum calculation
    --- @field strictssl           boolean  `CURLOPT_SSL_VERIFYHOST` + `CURLOPT_SSL_VERIFYPEER`
    --- @field nocheckanswer       boolean  Whether the reply is interpreted/logged and tried to be parsed
    --- @field nofollow            boolean  `CURLOPT_FOLLOWLOCATION` - follow HTTP 3xx redirects
    --- @field max_download_speed  string   `CURLOPT_MAX_RECV_SPEED_LARGE` - rate limit data download speed
    --- @field headers_to_send     table<string, string>  Header to send
    options = {
        url                = nil,
        cached_file        = nil,
        auth               = nil,
        request_body       = nil,
        iface              = nil,
        dry_run            = nil,
        cafile             = nil,
        sslkey             = nil,
        sslcert            = nil,
        ciphers            = nil,
        proxy              = nil,
        info               = nil,
        auth_token         = nil,
        content_type       = nil,
        retry_sleep        = nil,
        method             = nil,
        retries            = nil,
        low_speed_timeout  = nil,
        connection_timeout = nil,
        format             = nil,
        debug              = nil,
        usessl             = nil,
        strictssl          = nil,
        nocheckanswer      = nil,
        nofollow           = nil,
        max_download_speed = nil,
        headers_to_send    = nil,
    },

    --- Open a new channel.
    --
    --- @param  options  suricatta.channel.options  Channel default options overridable per operation
    --- @return boolean                             # Whether operation was successful or not
    --- @return table                               # Options of and operations on the opened channel
    open = function(options)
        --- Returned channel instance, on successful open.
        --
        --- @type  table<string, any>
        --- @class channel
        --- @field options  suricatta.channel.options  Channel creation-time set options
        --- @field get      function                   Channel get operation
        --- @field put      function                   Channel put operation
        --- @field close    function                   Channel close operation
        return {

            --- Channel creation-time set options as in `include/channel_curl.h`.
            --
            --- @type suricatta.channel.options
            options = {},

            --- Execute get operation over channel.
            --
            --- @param  options_get  suricatta.channel.options  Channel options for get operation
            --- @return boolean           # Whether operation was successful or not
            --- @return suricatta.status  # Suricatta return code
            --- @return table             # Operation results
            get = function(options_get)
                return {
                    --- @type number
                    http_response_code = nil,
                    --- @type suricatta.channel.content
                    format             = nil,
                    --- @type table | nil
                    json_reply         = nil, -- if request method was `suricatta.channel.content.JSON`
                    --- @type string | nil
                    raw_reply          = nil, -- if request method was `suricatta.channel.content.RAW`
                    --- @type table<string, string> | nil
                    received_headers   = nil,
                }
            end,

            --- Execute put operation over channel.
            --
            --- @param  options_put  suricatta.channel.options  Channel options for put operation
            --- @return boolean           # Whether operation was successful or not
            --- @return suricatta.status  # Suricatta return code
            --- @return table             # Operation results
            put = function(options_put)
                return {
                    --- @type number
                    http_response_code = nil,
                    --- @type suricatta.channel.content
                    format             = nil,
                    --- @type table | nil
                    json_reply         = nil, -- if request method was `suricatta.channel.content.JSON`
                    --- @type string | nil
                    raw_reply          = nil, -- if request method was `suricatta.channel.content.RAW`
                    --- @type table<string, string> | nil
                    received_headers   = nil,
                }
            end,

            --- Close channel.
            close = function() end,
        }
    end,
}


--- @type  table<string, any>
--- @class op_channel
--
-- Channel to use for the download / installation operation as returned by `suricatta.channel.open()`
-- plus channel options overriding the defaults per operation (@see suricatta.channel.options)
-- and specific options to the download / installation operation, e.g., `drain_messages`.
--
--- @field channel          channel                    Channel table as returned by `suricatta.channel.open()`
--- @field drain_messages?  boolean                    Whether to flush all progress messages or only those while in-flight operation (default)
--- @field ∈?               suricatta.channel.options  Channel options to override for this operation


--- Install an update artifact from remote server or local file.
--
-- If the protocol specified in Table `install_channel`'s `url` field is `file://`,
-- a local update artifact file is installed. If it is, e.g., `https://`, the
-- update artifact is downloaded *and* installed.
-- Note that this file is to be deleted, if applicable, from the Lua realm.
--
--- @see suricatta.download
--- @param  install_channel  op_channel  Channel to use for the download+installation operation
--- @return boolean                # Whether operation was successful or not
--- @return suricatta.status       # Suricatta return code
--- @return table<number, string>  # Error messages, if any
suricatta.install = function(install_channel) end

--- Download an update artifact from remote server.
--
-- `suricatta.download()` just downloads an update artifact from the remote server
-- without installing it. For later installation, call `suricatta.install()` with
-- an appropriate `install_channel` Table's `url` field.
--
--- @see suricatta.install
--- @param  download_channel  op_channel  Channel to use for the download operation
--- @param  localpath         string      Path where to store the downloaded artifact to
--- @return boolean                # Whether operation was successful or not
--- @return suricatta.status       # Suricatta return code
--- @return table<number, string>  # Error messages, if any
suricatta.download = function(download_channel, localpath) end


--- Sleep for a number of seconds.
--
-- Call SLEEP(3) via C realm.
--
--- @param seconds number  # Number of seconds to sleep
suricatta.sleep = function(seconds) end


--- Get TMPDIR from SWUpdate.
--
-- @see `core/util.c` :: get_tmpdir()
--
--- @return string  # TMPDIR path
suricatta.get_tmpdir = function() end


--- Get SWUpdate version.
--
--- @return table<string, number>  # Table with 'version' and 'patchlevel' fields
suricatta.getversion = function() end


return suricatta
