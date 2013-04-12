--[[
Author: Nathan Perry
Lab:6
Professor: Cripps
Due: 19th April 2011

Purpose: To show how lua can be used to search the web

Input: None
Output: File with websites with allows in robots.txt file

--]]
--require math library for random number generator
local math = require 'math'
local http = require "socket.http"
local ltn12 = require "ltn12"

local found = 0
local ignore = {10, 169, 172, 192}

--used to make sure the pseudo random number generator does not
--use the same number.
math.randomseed( os.time() )

--function to generate a random IP address
function randIP()
   ip1 = math.random(0, 255)
   ip2 = math.random(0, 255)
   ip3 = math.random(0, 255)
   ip4 = math.random(0, 255)
   return ip1, ip2, ip3, ip4 
end

while found ~= 2 do
   local ip
   local ip1
   local ip2
   local ip3
   ip1, ip2, ip3, ip4  = randIP()
   ip = (ip1.."."..ip2.."."..ip3.."."..ip4)

   for i,v in ipairs(ignore) do
      if ip1 ~= v then
         --[[
            Using http client library from LuaServer  (q.v.) to
            pull back web pages.
            This code copied from 
            http://www.wellho.co.uk/resources/ex.php4?item=u116/autobrowser
         --]]

         print ("\n============ First page ===========")

         status = http.request{
   	      url=ip,
	      sink = ltn12.sink.file(io.open("demo.txt","w"))
	       }
         print (status)

         print ("\n============ Second page ===========")
         page, status, auth = http.request(ip.."/robots.txt")
         print (page)
         print (status)
   
         found = found + 1
      end
   end
end
