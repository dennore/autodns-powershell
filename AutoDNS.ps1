### initial test release
# available commands
# Add-AutoDNSRecord($user,$pass,$zone,$name,$type='TXT',$ttl=300,$value)
# Remove-AutoDNSRecord($user,$pass,$zone,$name,$type='TXT',$ttl=300,$value)
# Get-AutoDNSZone($user,$pass,$zone)
# 
# examples:
# Add-AutoDNSRecord -user 123456 -pass secure123 -zone example.com -name test.example.com -type MX -pref 10 -ttl 3600 -value mail.test.com.
# Remove-AutoDNSRecord -user 123456 -pass secure123 -zone example.com -name test.example.com -type A -ttl 3600 -value 1.2.3.4
# Get-AutoDNSZone -user 123456 -pass secure123 -zone example.com
#


function Add-AutoDNSRecord($user,$pass,$zone,$name,$type='TXT',$ttl=300,$pref,$value) {
    $ns="a.ns14.net"
    $style="rr_add"
    $xmlpost ='<?xml version="1.0" encoding="utf-8"?>
    <request>
    <auth>
    <user>'+$user+'</user>
    <password>'+$pass+'</password>
    <context>4</context>
    </auth>
    <task>
    <code>0202001</code>
    <default>
    <'+$style+'>
    <name>'+$name+'</name>
    <type>'+$type+'</type>
    <pref>'+$pref+'</pref>
    <ttl>'+$ttl+'</ttl>
    <value>'+$value+'</value>
    </'+$style+'>
    </default>
    <zone>
    <name>'+$zone+'</name>
    <system_ns>'+$ns+'</system_ns>
    </zone>
    </task>
    </request>'
    $result = Invoke-RestMethod -URI https://gateway.autodns.com -body $xmlpost -Method post
    return $result.response.result.msg.text
}

function Get-AutoDNSZone($user,$pass,$zone) {
    $xmlpost ='<?xml version="1.0" encoding="utf-8"?>
    <request>
    <auth>
    <user>'+$user+'</user>
    <password>'+$pass+'</password>
    <context>4</context>
    </auth>
    <task>
    <code>0205</code>
    <zone>
    <name>'+$zone+'</name>
    <system_ns>a.ns14.net</system_ns>
    </zone>
    <key></key>
    </task>
    </request>'
    $result = Invoke-RestMethod -URI https://gateway.autodns.com -body $xmlpost -Method post
    return $result.response.result.data.zone.rr
}

function Remove-AutoDNSRecord($user,$pass,$zone,$name,$type='TXT',$pref,$ttl=300,$value) {
    $ns="a.ns14.net"
    $style="rr_rem"
    $xmlpost ='<?xml version="1.0" encoding="utf-8"?>
    <request>
    <auth>
    <user>'+$user+'</user>
    <password>'+$pass+'</password>
    <context>4</context>
    </auth>
    <task>
    <code>0202001</code>
    <default>
    <'+$style+'>
    <name>'+$name+'</name>
    <type>'+$type+'</type>
    <pref>'+$pref+'</pref>
    <ttl>'+$ttl+'</ttl>
    <value>'+$value+'</value>
    </'+$style+'>
    </default>
    <zone>
    <name>'+$zone+'</name>
    <system_ns>'+$ns+'</system_ns>
    </zone>
    </task>
    </request>'
    $result = Invoke-RestMethod -URI https://gateway.autodns.com -body $xmlpost -Method post
    return $result.response.result.msg.text
}
