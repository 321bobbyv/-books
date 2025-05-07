/-  spider, *books
/+  *strandio
::
=,  strand=strand:spider
::
|%
+$  ccru  (unit client-response:iris)
+$  almost-trans
  $:  id=@ud
      tokenid=@ud
      estimatedvalueeth=(unit @rd)
      originalurl=@t
      address=@ux
      network=@t
      name=@t
      nftstandard=@t
      openseaid=@t
  ==
--
::
|^  call-zapper
::
++  gth-num
  |=  [a=[p=@ud q=@ux] b=[p=@ud q=@ux]]
  ?:(=(p.a p.b) (gth q.a q.b) (gth p.a p.b))
::
++  make-http-request
  |=  [uid=@t pwd=@t urb-address=@ux]
  ?~  p=(rush (scot %ux urb-address) ;~(pfix (jest '0x') (more dot (star aln))))  !!
  =;  [authorization=@t web-address=@t]
   ^-  request:http
   :+  %'GET'
     %^  cat  3
       'https://api.zapper.xyz/v2/nft/user/tokens?userAddress='
     (cat 3 '0x' web-address)
   :_  ~
   :~  'Authorization'^(cat 3 'Basic ' authorization)
       'User-Agent'^'urbit_books'
   ==
  :_  (crip (zing u.p))
  (en:base64:mimes:html (as-octs:mimes:html (rap 3 ~[uid ':' pwd])))
::
++  json-to-dino
  |=  [jon=json addy=@ux]
  |^  ^-  (list nft-transaction)
  =/  error=(unit @t)
    ((ot:dejs-soft:format [%message so:dejs-soft:format]~) jon)
  ?.  ?=(~ error)  ~
  =,  dejs:format
  %.  jon
      %-  ar  %-  ot
      :~  tokenid+so
          estimatedvalueeth+ne-string
          originalurl+so
          address+(su:dejs-soft:format ;~(pfix (jest '0x') hex))
          network+so
          name+so
          nftstandard+so
          openseaid+so
      ==
  ::++  du-string
  ::  |=  jon=^json
  ::  =,  dejs:format
  ::  ^-  @da
   :: ?>  ?=([%s *] jon)
   :: ((cu from-unix:chrono:userlib ni) [%n +.jon])
  ++  ne-string
    |=  jon=^json
    =,  dejs:format
    ^-  @rd
    ?>  ?=([%s *] jon)
    (rash p.jon (cook ryld (cook royl-cell:^so json-rn)))
  ++  ne-soft-string
    |=  jon=^json
    =,  dejs-soft:format
    ^-  (unit @rd)
    ?.  ?=([%s *] jon)  ~
    (rush p.jon (cook ryld (cook royl-cell:^so json-rn)))
  ++  from-sub
    =,  dejs:format
    %-  ot
    :~  type+(se %tas)
        symbol+so
        amount+ne
        address+(su:dejs-soft:format ;~(pfix (jest '0x') hex))
    ==
  --
::
::  main thread
::
++  call-zapper
  ^-  thread:spider
  |=  prep=vase
  =/  m  (strand ,vase)
  ^-  form:m
  =/  uber
    !<  $:  ~
            ::bol=bowl:gall 
            uid=@t
            pw=@t
            addresses=(set @ux)
            trans=((mop ,[p=@ud q=@ux] nft-transaction) gth-num)
        ==
    prep
  =/  addy  ~(tap in addresses.uber)
  =|  leg=(list nft-transaction)
  ::=,  bol.uber
  |-  ?~  addy
    =;  vaz=vase
      (pure:m vaz)
    !>  ^-  $:  ((mop ,[p=@ud q=@ux] nft-transaction) gth-num)
                (list [[@ud @ux] nft-transaction])
            ==
    =-  :-  next
        %~  tap  by
        %-  %~  dif  by  (malt leg)
        (malt (tap:((on ,[p=@ud q=@ux] nft-transaction) gth-num) trans.uber))
    next=(gas:((on ,[p=@ud q=@ux] nft-transaction) gth-num) trans.uber leg)
  ;<  ~      bind:m  (send-request (make-http-request uid.uber pw.uber i.addy))
  ;<  =ccru  bind:m  take-maybe-response
  ?~  ccru  $(addy t.addy)
  ;<  r=@t   bind:m  (extract-body u.ccru)
  ?~  jun=(de:json:html r)  $(addy t.addy)
  %=  $
    leg   (weld (json-to-dino u.jun i.addy) leg)
    addy  t.addy
  ==
--