/-  spider::import spider structure library
/+  strandio::import strandio library
!:
::turn on stack trace with !:
=,  strand=strand:spider
|%
+$  ccru  (unit client-response:iris)
+$  getbalance-trans
  $:  network=@tas
      result=@ud
  ==
--
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ arg=(set @ux)] arg)::devase incoming
::=/  arg2  ~(key by arg)::Pull the key values out using keyby - Produces a set of all keys in map a.
=/  arg3  ~(tap in arg)::Convert a set to a list:  tap:in -Flattens a set into a list
=/  hextocord  |=(x=@ux (crip ['0' 'x' ((x-co:co (met 3 x)) x)]))
=/  arg4  (turn arg3 hextocord)
=/  arg5  (crip (join ',' arg4))::Constructs a new list, placing a "," between every element
=/  base-url  "https://api.etherscan.io/api?module=account&action=balancemulti&address="
=/  base-url2  "&tag=latest&apikey=GCBRCSK9Q1AFMW6QUT35223FI29YGQRMS2"
=/  url  (weld base-url (weld (trip arg5) base-url2))::Contruct URL to hit etherscan api
;<  pokeinfo=json  bind:m  (fetch-json:strandio url)
=/  zz  (ar:dejs:format (ot ~[account+so balance+so]):dejs:format)
=/  g  ((ot:dejs:format ~[result+zz]) pokeinfo)::parse "pokeinfo" results from etherscan to an array
=/  h  `(map account=@t balance=@t)`(malt g)::cast it as a map of cord's
::Use scow to convert the balance from a cord('') to a tape(" ") and then scan dim:ag to parse a tape("") to a decimal number.
=/  j  (~(urn by h) |=([k=@ v=@] (scan (scow %tas v) dim:ag)))::convert account balance from cord to number
(pure:m !>(pokeinfo))