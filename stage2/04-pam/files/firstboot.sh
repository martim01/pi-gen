#!/bin/bash
#setcap 
setcap cap_sys_time,cap_net_bind_service+ep /usr/local/bin/pam2
