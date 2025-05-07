/-  spider::import spider structure library
/+  strandio::import strandio library
!:
::turn on stack trace with !:
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ arg=(set @ux)] arg)::devase incoming
::=/  arg1  ~(key by arg)::Pull the key values out using keyby - Produces a set of all keys in map a.
=/  a  ~(tap in arg)::Convert a set to a list:  tap:in -Flattens a set into a list
=+  b=`_a`~
=+  map1=`(map tokenid=@t [name=@t description=@t])`~
|-  ?~  a  (pure:m !>(map1))
=/  base-url  "https://eth-mainnet.g.alchemy.com/nft/v3/9jA3fTcWf-YiCoYRGsedmbeD_T1CiEeu/getNFTsForOwner?owner="
=/  base-url2  "&withMetadata=true&pageSize=100"
=/  c  (crip ['0' 'x' ((x-co:co (met 3 i.a)) i.a)])
~&  [%c c]
=/  url  (weld base-url (weld (trip c) base-url2))::Contruct URL to hit etherscan api
;<  ~      bind:m  (sleep:strandio ~s1)
;<  pokeinfo=json  bind:m  (fetch-json:strandio url)
=/  zz  (ar:dejs:format (ou ~['tokenId' so]):dejs:format)
=/  g  ((ot:dejs:format [['ownedNfts' zz] ~]) pokeinfo)::parse "pokeinfo" results from etherscan to an array
=/  h  `(map tokenid=@t)`(malt g)::cast it as a map of cord's
~&  [%h h]
=/  map2  `(map tokenid=@t [name=@t description=@t])`(~(uni by map1) h)
~&  [%map2 map2]
$(a t.a, b [i.a b], map1 map2)