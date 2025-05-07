/-  spider::import spider structure library
/+  strandio::import strandio library
!:
::turn on stack trace with !:
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ arg=@t] arg)::devase incoming
=/  base-url  "https://eth-mainnet.g.alchemy.com/nft/v3/9jA3fTcWf-YiCoYRGsedmbeD_T1CiEeu/getNFTsForOwner?owner="
=/  base-url2  "&withMetadata=true&pageSize=100"
=/  url  (weld base-url (weld (trip arg) base-url2))::Contruct URL to hit etherscan api
;<  pokeinfo=json  bind:m  (fetch-json:strandio url)
(pure:m !>(pokeinfo))