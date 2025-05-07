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
=+  map1=`(map timestamp=@t [hash=@t from=@t to=@t value=@t gas=@t gasused=@t])`~
|-  ?~  a  (pure:m !>(map1))
~&  map1
=/  base-url  "https://api.etherscan.io/api?module=account&action=txlist&address="
=/  base-url2  "&startblock=0&endblock=99999999&page=1&offset=10&sort=asc&apikey=GCBRCSK9Q1AFMW6QUT35223FI29YGQRMS2"
=/  c  (crip ['0' 'x' ((x-co:co (met 3 i.a)) i.a)])
=/  url  (weld base-url (weld (trip c) base-url2))::Contruct URL to hit etherscan api
;<  pokeinfo=json  bind:m  (fetch-json:strandio url)
=/  zz  (ar:dejs:format (ot ~[['timeStamp' so] hash+so from+so to+so value+so gas+so ['gasUsed' so]]):dejs:format)
=/  g  ((ot:dejs:format ~[result+zz]) pokeinfo)::parse "pokeinfo" results from etherscan to an array
=/  h  `(map timestamp=@t [hash=@t from=@t to=@t value=@t gas=@t gasused=@t])`(malt g)::cast it as a map of cord's
=/  map2  `(map timestamp=@t [hash=@t from=@t to=@t value=@t gas=@t gasused=@t])`(~(uni by map1) h)
$(a t.a, b [i.a b], map1 map2)