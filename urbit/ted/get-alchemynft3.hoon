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
=/  c  (crip ['0' 'x' ((x-co:co (met 3 arg)) arg)])
=/  arg3  ~(tap in arg)
=/  base-url  "https://eth-mainnet.g.alchemy.com/nft/v3/9jA3fTcWf-YiCoYRGsedmbeD_T1CiEeu/getNFTsForOwner?owner="
=/  base-url2  "&withMetadata=true&pageSize=100"
=/  url  (weld base-url (weld (trip arg) base-url2))::Contruct URL to hit etherscan api
;<  pokeinfo=json  bind:m  (fetch-json:strandio url)
=/  zz  (ar:dejs:format (ot ~[['tokenId' so] name+so description+so]):dejs:format)
=/  g  ((ot:dejs:format [['ownedNfts' zz] ~]) pokeinfo)::parse "pokeinfo" results from etherscan to an array
=/  h  `(map tokenid=@t [name=@t description=@t])`(malt g)::cast it as a map of cord's
(pure:m !>(h))