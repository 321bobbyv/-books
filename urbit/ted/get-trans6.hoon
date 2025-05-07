/-  spider::import spider structure library
/+  strandio::import strandio library
!:
::turn on stack trace with !:
=,  strand=strand:spider
|^  call-zapper
++  gth-hex
    |=  [a=[p=@da q=@ux] b=[p=@da q=@ux]]
    ?:(=(p.a p.b) (gth q.a q.b) (gth p.a p.b))
++  gth-num
  |=  [a=[p=@ud q=@ux] b=[p=@ud q=@ux]]
  ?:(=(p.a p.b) (gth q.a q.b) (gth p.a p.b))
++  call-zapper  
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ arg=(set @ux)] arg)::devase incoming
::=/  arg1  ~(key by arg)::Pull the key values out using keyby - Produces a set of all keys in map a.
=/  a  ~(tap in arg)::Convert a set to a list:  tap:in -Flattens a set into a list
=+  b=`_a`~
=/  myon  ((on ,blocknumber=@t [timestamp=@t hash=@t from=@t destination=@t amount=@t txgas=@t gasused=@t]) gth)
=+  mop1=`((mop blocknumber=@t [timestamp=@t hash=@t from=@t destination=@t amount=@t txgas=@t gasused=@t]) gth)`~
|-  ?~  a  (pure:m !>(mop1))
=/  base-url  "https://api.etherscan.io/api?module=account&action=txlist&address="
=/  base-url2  "&startblock=0&endblock=99999999&page=1&offset=10&sort=asc&apikey=GCBRCSK9Q1AFMW6QUT35223FI29YGQRMS2"
=/  c  (crip ['0' 'x' ((x-co:co (met 3 i.a)) i.a)])
=/  url  (weld base-url (weld (trip c) base-url2))::Contruct URL to hit etherscan api
;<  ~  bind:m  (sleep:strandio ~s1)
;<  pokeinfo=json  bind:m  (fetch-json:strandio url)
=/  zz  (ar:dejs:format (ot ~[['blockNumber' so] ['timeStamp' so] hash+so from+so to+so value+so gas+so ['gasUsed' so]]):dejs:format)::change the order
=/  g  ((ot:dejs:format ~[result+zz]) pokeinfo)::parse "pokeinfo" results from etherscan to an array
=/  h  (gas:myon mop1 g)
$(a t.a, b [i.a b], mop1 h)
--