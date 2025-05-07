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
=+  !<([~ arg=(map @t [@t @t @ud])] arg)::devase incoming
=/  arg2  ~(key by arg)::Pull the key values out using keyby - Produces a set of all keys in map a.
=/  arg3  ~(tap in arg2)::Convert a set to a list:  tap:in -Flattens a set into a list
=/  arg4  (crip (join ',' arg3))::Constructs a new list, placing a "," between every element
=/  base-url  "https://api.etherscan.io/api?module=account&action=balancemulti&address="
=/  base-url2  "&tag=latest&apikey=GCBRCSK9Q1AFMW6QUT35223FI29YGQRMS2"
=/  arg1  '0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a,0x63a9975ba31b0b9626b34300f7f627147df1f526,0x198ef1ec325a96cc354c7266a038be8b5c558f67'
=/  url  (weld base-url (weld (trip arg4) base-url2))::Contruct URL to hit etherscan api
;<  pokeinfo=json  bind:m  (fetch-json:strandio url)
=/  zz  (ar:dejs:format (ot ~[account+so balance+so]):dejs:format)
=/  g  ((ot:dejs:format ~[result+zz]) pokeinfo)::parse "pokeinfo" results from etherscan to an array
=/  h  `(map @t @t)`(malt g)::cast it as a map of cord's
::Use scow to convert the balance from a cord('') to a tape(" ") and then scan dim:ag to parse a tape("") to a decimal number.
=/  j  (~(urn by h) |=([k=@ v=@] (scan (scow %tas v) dim:ag)))::convert account balance from cord to number
(pure:m !>(j))