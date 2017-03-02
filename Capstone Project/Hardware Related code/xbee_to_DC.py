############################################################################
#                                                                          #
# Copyright (c)2014, Digi International (Digi). All Rights Reserved.       #
#                                                                          #
# Permission to use, copy, modify, and distribute this software and its    #
# documentation, without fee and without a signed licensing agreement, is  #
# hereby granted, provided that the software is used on Digi products only #
# and that the software contain this copyright notice,  and the following  #
# two paragraphs appear in all copies, modifications, and distributions as #
# well. Contact Product Management, Digi International, Inc., 11001 Bren   #
# Road East, Minnetonka, MN, +1 952-912-3444, for commercial licensing     #
# opportunities for non-Digi products.                                     #
#                                                                          #
# DIGI SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED   #
# TO, THE IMPLIED WARRANTIES OF MERCHANT ABILITY AND FITNESS FOR A         #
# PARTICULAR PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, #
# PROVIDED HERE UNDER IS PROVIDED "AS IS" AND WITHOUT WARRANTY OF ANY KIND.#
# DIGI HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,         #
# ENHANCEMENTS, OR MODIFICATIONS.                                          #
#                                                                          #
# IN NO EVENT SHALL DIGI BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,      #
# SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,   #
# ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF   #
# DIGI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.                #
#                                                                          #
############################################################################
 
'''
XBEE DATA TO DEVICE CLOUD DATA POINTS SAMPLE APPLICATION
 
This application gathers data from a Digi Gateways zigbee interface and then
pushes it up to the Digi Device Cloud.
 
Platforms:    Digi Connect Port: X2, X4, X2e
Date:         4/22/14
 
Assumption(s):
- The gateway is tied to a user account and is showing up as 'connected'.
- The gateway has at least one other Zigbee node than itself.
 
Details:
 
DataPoints are talked about in the Digi Device Cloud Programmers Guide.  This
document is available at https://login.etherios.com.  You'll need to login and go to the:
'Documentation -> Resources -> Device Cloud Programmers Guide'
 
Zigbee:
The Digi Gateway will have a Zigbee capability.  This allows it to communicate
on it's 'mesh network'.  
 
 
Data Streams Defined:
The Data Streams API allows data to be stored in a time series for long 
periods of time. Data streams represent time series data, a sequence of data 
points. You can create a data streams with web services by uploading data 
points, or using the DIA or Smart Energy frameworks with Device Cloud. You can
query the data by time ranges, roll-up intervals, and perform basic aggregates.
 
Time series data involves two concepts: data points and data streams.
 
Data points are the individual values which are stored at specific times.
Data streams are containers of data points. Data streams hold meta data 
bout the data points held within them. The data streams and the data points
they hold are addressed using hierarchical paths (much like folders).
 
 
 
'''
 
import sys
import os
import socket
import select
import binascii
import idigidata
import xbee
import time
 
def fmt_dp(data, streamid, timestamp=None, datatype=None, units=None):
    fmt_str = "<DataPoint><data>" + str(data) + "</data><streamId>" + streamid + "</streamId>"+
    if datatype: fmt_str += "<dataType>" + datatype + "</dataType>"
    if units: fmt_str += "<units>" + units + "</units>"
    if timestamp: fmt_str += "<timestamp>" + str(int(timestamp)) + "</timestamp>"
    fmt_str += "</DataPoint>"
    return fmt_str
 
print "Starting Application"
 
# Check platform of gateway.  it's either NDS or Digi Embedded Linux
if sys.version_info < (2, 6):
    print "Running NDS"
    sock = socket.socket(socket.AF_ZIGBEE, socket.SOCK_DGRAM, socket.ZBS_PROT_TRANSPORT)
else:
    print "Running DBL"
    sock = socket.socket(socket.AF_ZIGBEE, socket.SOCK_DGRAM, socket.XBS_PROT_TRANSPORT)
 
# Determine if the xbee modem in the Digi gateway is using 'Zigbee' or 
# 'DigiMesh' firmware.  Then bind accordingly.
if ord(xbee.ddo_get_param(None, 'VR')[0]) == 0x10:
    print "Binding to Digi Mesh"
    sock.bind(("", 0x00, 0, 0))
else:
    print "Binding to Zigbee"
    sock.bind(("", 0xe8, 0, 0))
 
# start our loop listening for xbee data
while True:
    rs, ws, es = select.select([sock], [], [], 2)
    for r in rs:
        payload, src_addr = sock.recvfrom(200)
        output = "src_addr:"
        for item in src_addr:
            try: output += " [0x%0X]" % item
            except Exception, e: output += " [" + str(item) + "]"
        print output
 
 
        upload_data = fmt_dp(payload, output, time.time() * 1000, "Integer")
        status, number, error_msg = idigidata.send_to_idigi(upload_data, "DataPoint/stream.xml")
        if not status: print "DC Upload Error: " + str(number) + " " + error_msg
        else: print "Successfully uploaded data!"