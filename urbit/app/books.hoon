::  /app/books
::
/-  *books, hark
/+  default-agent, dbug

|%
+$  versioned-state
  $%  [%0 state-zero]
  ==
::
::  state-zero
::  - zapper-token: zapper.fi uid + password, defaulting to public
::  - transactions: a mop of zapper timestamps to transaction data
::  - tags: tags you've used for wallets, transactions
::  - wallet-states: your wallet account balances
::  - held-wallets: your wallets - a map of addresses to metadatas
::  - lilblackbook: your friends - a map of addresses to metadatas
::  - eth-transactions - eth transactions from etherscan
::  - nft-transactions - nft transactions from etherscan
::  - transactions: your transactions, stored, as a mop
::  - elucidations: your notes - a map of trxhashes to annotations.
::
::
+$  state-zero
  $:  zapper-token=[uid=@t pw=@t]
      etherscankey=@t
      tags=(set @tas)
    ::
      held-wallets=(map @ux [nick=@t tags=(set @tas)])
      wallet-states=(map walletaddress=@t balance=@ud)
      lilblackbook=(map @ux wallet)
    ::
      transactions=((mop ,[p=@da q=@ux] transaction) gth-hex)
      eth-transactions=(map timestamp=@t [hash=@t from=@t to=@t value=@t gas=@t gasused=@t])
      nft-transactions=(map blocknumber=@t [timestamp=@t hash=@t from=@t to=@t tokenid=@t tokenname=@t tokensymbol=@t gas=@t])
      elucidations=(map @ux annotation)
  ==
::
+$  card  card:agent:gall
::
::  sort helper
::
++  gth-hex
  |=  [a=[p=@da q=@ux] b=[p=@da q=@ux]]
  ?:(=(p.a p.b) (gth q.a q.b) (gth p.a p.b))

++  gth-num
  |=  [a=[p=@ud q=@ux] b=[p=@ud q=@ux]]
  ?:(=(p.a p.b) (gth q.a q.b) (gth p.a p.b))

++  hextocord
|=  x=@ux
(crip ['0' 'x' ((x-co:co (met 3 x)) x)])

++  cordtohex
|=  c=@t
`@ux`(rash c ;~(pfix (jest '0x') hex))
::
--
::
%-  agent:dbug
::
=|  [%0 state-zero]
=*  state  -
::
^-  agent:gall
::
::
=<
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %|) bowl)
      is    ~(. +> bowl)
  ++  on-init
    ^-  (quip card _this)
    =.  etherscankey  'GCBRCSK9Q1AFMW6QUT35223FI29YGQRMS2'
    =.  zapper-token
      ['afbb9d40-3fbb-44cc-a470-c704a5364981' '']
    =+  new=(add now.bowl ~m30)
    %-  (slog leaf+"%books-online" ~)
    :_  this
    [%pass /books/timer [%arvo %b [%wait new]]]~
  ::
  ++  on-save
    ^-  vase
    !>(state)
  ::
  ++  on-load
    |=  ole=vase
    =/  old=versioned-state  !<(versioned-state ole)
    |-
    ?-    -.old
        %0
      %-  (slog leaf+"%books-reloaded" ~)
      `this(state old)
    ==
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    ?>  =(our.bowl src.bowl)
    ?+    mark  (on-poke:def mark vase)
        %books-page
      =/  vaz=page  !<(page vase)
      =^  cards  state
        ?-  -.vaz
          %change-zapper-creds  (zip-zap:gilt:is +.vaz)
          %etherscan-key        (eth-key:gilt:is +.vaz)
          %add-transaction      (add-dis:gilt:is +.vaz)
          %add-wallet           (add-wal:gilt:is +.vaz)
          %del-wallet           (del-wal:gilt:is +.vaz)
          %add-friend           (add-bud:gilt:is +.vaz)
          %del-friend           (del-bud:gilt:is +.vaz)
          %annotation           (pen-pad:gilt:is +.vaz)
          %del-a-note           (rub-rub:gilt:is +.vaz)
          %set-tags             (tag-man:gilt:is +.vaz)
          %set-nick             (nic-nam:gilt:is +.vaz)
          %set-patp             (mah-guy:gilt:is +.vaz)
          %re-fresh             up-date:gilt:is
        ==
      [cards this]
    ==
  ::
  ++  on-watch
    |=  pat=path
    ?+    pat  (on-watch:def pat)
        [%website ~]
      :_  this
      :~  ::(zapper-fi:uber:is /full)
          (get-nft:uber)
          (get-balance:uber)
          (get-trans:uber)
          note-send:uber:is
          [%give %fact ~ json+!>(rolo-send:uber:is)]
      ==
    ==
  ++  on-arvo
    |=  [=wire sign=sign-arvo]
    ?+  wire  (on-arvo:def wire sign)
        [%books %timer ~]
      =+  new=(add now.bowl ~m30)
      :_  this
      :~  (get-trans:uber)
          ::(zapper-fi:uber)
          (get-nft:uber)
          (get-balance:uber)
        [%pass /books/timer [%arvo %b [%wait new]]]   
      ==
    ::
        [%books %do %nix ~]
      ?>  ?=([%khan %arow *] sign)
      ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
      ?>  ?=(%noun -.p.p.+.sign)
      =/  upd
        !<  $:  p=((mop ,[p=@da q=@ux] transaction) gth-hex)
                q=(list [[@da @ux] transaction])
            ==
        +.p.p.+.sign
      :_  this(transactions p.upd)
      =,  enjs:format
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
        %-  pairs
        :~  head+s+'del-transactions'
            tran+a+(transactions:en-json:is p.upd)
        ==
    ::
        [%books %do %note ~]
      ?>  ?=([%khan %arow *] sign)
      ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
      ?>  ?=(%noun -.p.p.+.sign)
      =/  jon  !<(json +.p.p.+.sign)
      [[%give %fact ~[/website] json+!>(jon)]~ this]
    ::
      [%books %do %get-balance ~]
      ?>  ?=([%khan %arow *] sign)
      ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
      ?>  ?=(%noun -.p.p.+.sign)
      =/  bal  
        !<  (map walletaddress=@t balance=@ud)  +.p.p.+.sign
      :_  this(wallet-states bal)
      =,  enjs:format
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
        %-  pairs:enjs:format
        :~  head+s+'update-wallet-balance'
            tran+(enjsonbalance:en-json:is bal)
        ==
      ::
         [%books %do %del-balance ~]
      ?>  ?=([%khan %arow *] sign)
      ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
      ?>  ?=(%noun -.p.p.+.sign)
      =/  bal  
        !<  (map walletaddres=@t balance=@ud)  +.p.p.+.sign
      :_  this(wallet-states bal)
      =,  enjs:format
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
        %-  pairs:enjs:format
        :~  head+s+'update-wallet-balance'
            tran+(enjsonbalance:en-json:is bal)
        ==
    :: do subscription update
     [%books %do %get-trans ~]
      ?>  ?=([%khan %arow *] sign)
      ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
      ?>  ?=(%noun -.p.p.+.sign)
      =/  trans-thread  
        !<  (map timestamp=@t [hash=@t from=@t to=@t value=@t gas=@t gasused=@t])  +.p.p.+.sign
      :_  this(eth-transactions (~(uni by eth-transactions) trans-thread))
      =,  enjs:format
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
        %-  pairs:enjs:format
        :~  head+s+'update-ethtrans'
            tran+(enjsontrans:en-json trans-thread)
        ==
      ::
    [%books %do %del-trans ~]
      ?>  ?=([%khan %arow *] sign)
      ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
      ?>  ?=(%noun -.p.p.+.sign)
      =/  trans-thread  
        !<  (map timestamp=@t [hash=@t from=@t to=@t value=@t gas=@t gasused=@t])  +.p.p.+.sign
      :_  this(eth-transactions (~(uni by eth-transactions) trans-thread))
      =,  enjs:format
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
        %-  pairs:enjs:format
        :~  head+s+'update-ethtrans'
            tran+(enjsontrans:en-json:is trans-thread)
        ==
      ::
       [%books %do %get-nft ~]
      ?>  ?=([%khan %arow *] sign)
      ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
      ?>  ?=(%noun -.p.p.+.sign)
      =/  nft-thread
        !<  (map blocknumber=@t [timestamp=@t hash=@t from=@t to=@t tokenid=@t tokenname=@t tokensymbol=@t gas=@t])  +.p.p.+.sign
      :_  this(nft-transactions (~(uni by nft-transactions) nft-thread))
      =,  enjs:format
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
        %-  pairs:enjs:format
        :~  head+s+'update-nfts'
            tran+(enjsonnft:en-json:is nft-thread)
        ==
      ::
      [%books %do %del-nft ~]
      ?>  ?=([%khan %arow *] sign)
      ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
      ?>  ?=(%noun -.p.p.+.sign)
      =/  nft-thread  
      ::`(map blocknumber=@t [hash=@t from=@t to=@t tokenid=@t tokenname=@t tokensymbol=@t gas=@t])
        !<  (map blocknumber=@t [timestamp=@t hash=@t from=@t to=@t tokenid=@t tokenname=@t tokensymbol=@t gas=@t])  +.p.p.+.sign
      :_  this(nft-transactions (~(uni by nft-transactions) nft-thread))
      =,  enjs:format
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
        %-  pairs:enjs:format
        :~  head+s+'update-nfts'
            tran+(enjsonnft:en-json:is nft-thread)
      ==
      ::
           [%books %do %zap *]
      ?+    +>+.wire  !!
          [%full ~]
        ?>  ?=([%khan %arow *] sign)
        ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
        ?>  ?=(%noun -.p.p.+.sign)
        =/  upd  ::=[p=((mop ,[p=@da q=@ux] transaction) gth-hex) q=(list [[@da @ux] transaction])]
          !<  $:  p=((mop ,[p=@da q=@ux] transaction) gth-hex)
                  q=(list [[@da @ux] transaction])
              ==
          +.p.p.+.sign
          ~&  [%zapreturnthreadupd upd]
        =.  transactions
          %.  [transactions p.upd]
          uni:((on ,[@da @ux] transaction) gth-hex)
        :_  this
        =,  enjs:format
        =-  [%give %fact ~[/website] json+!>(`json`-)]~
        %-  pairs
        :~  head+s+'transactions'
            tran+a+(transactions:en-json:is p.upd)
        ==
      ::
          [%some ~]
        ?>  ?=([%khan %arow *] sign)
        ?.  ?=(%& -.p.+.sign)  ((slog +.p.p.+.sign) `this)
        ?>  ?=(%noun -.p.p.+.sign)
        =/  upd  ::=[p=((mop ,[p=@da q=@ux] transaction) gth-hex) q=(list [[@da @ux] transaction])]
          !<  $:  p=((mop ,[p=@da q=@ux] transaction) gth-hex)
                  q=(list [[@da @ux] transaction])
              ==
          +.p.p.+.sign
        =.  transactions
          %.  [transactions p.upd]
          uni:((on ,[@da @ux] transaction) gth-hex)
        :_  this
        =,  enjs:format
        =-  [%give %fact ~[/website] json+!>(`json`-)]~
        %-  pairs
        :~  head+s+'transactions'
          ::
            :+  %tran  %a
            %-  transactions:en-json:is
            (gas:((on ,[p=@da q=@ux] transaction) gth-hex) *((mop ,[p=@da q=@ux] transaction) gth-hex) q.upd)
        ==
      ::
          [%when ~]
        ?>  ?=([%khan %arow *] sign)
        ?.  ?=(%& -.p.sign)
          ((slog +.p.p.sign) `this)
        ?>  ?=(%noun -.p.p.sign)
        =/  upd
          !<  $:  p=((mop ,[p=@da q=@ux] transaction) gth-hex)
                  q=(list [[@da @ux] transaction])
              ==
          +.p.p.+.sign
        =.  transactions
          %.  [transactions p.upd]
          uni:((on ,[@da @ux] transaction) gth-hex)
        `this
      ==
    ==
  ++  on-fail   on-fail:def
  ++  on-peek   on-peek:def
  ++  on-agent  on-agent:def
  ++  on-leave  on-leave:def
  --
|_  bol=bowl:gall
++  send-hark
  |=  [who=ship msg=cord]
  ::^+  %is
  ::?.  send-alerts  %is
  ::?.  .^(? %gu /(scot %p our.bowl)/hark/(scot %da now.bowl)/$)
  ::  %is
  :: [ship+who msg]~
  =/  con=(list content:hark)  [msg]~
  =/  =id:hark      (end 7 (shas %book-notification eny.bol))
  ::=/  =rope:hark    [~ ~ q.byk.bowl /(scot %p who)/[dap.bowl]]
  =/  =rope:hark  [gop=~ can=~ des=%books ted=/~bes/books]
  =/  =action:hark  [%add-yarn & & id rope now.bol con /[dap.bol] ~]
  ~&  "actionhark:  {<action>}"
  =/  =cage         [%hark-action !>(action)]
  [%pass /hark %agent [our.bol %hark] %poke cage]
++  uber                                                 ::  khan helpers
  |%
  ++  note-send
    ^-  card
    :^  %pass  /books/do/note  %arvo
    [%k %fard %books %send-notes %noun !>([bol elucidations])]
  ++  nix-trans::delete arm
    ^-  card
    :^  %pass  /books/do/nix  %arvo
    =-  [%k %fard %books %del-trans %noun !>(-)]
    ^-  [bowl:gall @t @t (set @ux) ((mop ,[p=@da q=@ux] transaction) gth-hex)]
    [bol uid.zapper-token pw.zapper-token ~(key by held-wallets) transactions]
    ::
  ++  del-trans
    |=  p=path
    ^-  card
    :^  %pass  (weld /books/do/del-trans p)  %arvo
    [%k %fard %books %del-trans %noun !>([~ ~(key by held-wallets)])]
    ::
  ++  zapper-fi
    |=  p=path
    ^-  card
    :^  %pass  (weld /books/do/zap p)  %arvo
    =-  [%k %fard %books %get-transactions %noun !>(-)]
    ^-  [bowl:gall @t @t (set @ux) ((mop ,[p=@da q=@ux] transaction) gth-hex)]
    [bol uid.zapper-token pw.zapper-token ~(key by held-wallets) transactions]
    ::
  ++  get-nft
    |=  p=path
    ^-  card
    :^  %pass  (weld /books/do/get-nft p)  %arvo
    [%k %fard %books %get-nft %noun !>([~ ~(key by held-wallets)])]
    ::
  ++  del-nft
    |=  p=path
    ^-  card
    :^  %pass  (weld /books/do/del-nft p)  %arvo
    [%k %fard %books %del-nft %noun !>([~ ~(key by held-wallets)])]
    ::
  ++  get-trans
    |=  p=path
    ^-  card
    :^  %pass  (weld /books/do/get-trans p)  %arvo
    ::[%k %fard %books %get-trans3 %noun !>(`held-wallets)]
    [%k %fard %books %get-trans %noun !>([~ ~(key by held-wallets)])]
    ::
  ++  get-balance
    |=  p=path
    ^-  card
    :^  %pass  (weld /books/do/get-balance p)  %arvo
    ::[%k %fard %books %get-balance %noun !>(`held-wallets)]
    [%k %fard %books %get-balance %noun !>([~ ~(key by held-wallets)])]
::
 ++  del-balance
    |=  p=path
    ^-  card
    :^  %pass  (weld /books/do/del-balance p)  %arvo
    ::[%k %fard %books %get-balance %noun !>(`held-wallets)]
    [%k %fard %books %del-balance %noun !>([~ ~(key by held-wallets)])] 
::
  ++  rolo-send
    ^-  json
    =,  enjs:format
    %-  pairs
    :~  head+s+'wallets'
      :+  'fren'  %a
      ^-  (list json)
      %-  ~(rep by lilblackbook)
      |=  [[a=@ux w=wallet] j=(list json)]
      :_  j  :-  %a
      ::  here, we're sending a list of mini-arrays to 
      ::  mirror the structure of a Map Object from 
      ::  Immutable.js
      :: - https://immutable-js.com/docs/latest@main/Map/
      ^-  (list json)
      :~  s+(scot %ux a)
        ::
          %-  pairs
          :~  nick+s+nick.w
              who+s+?~(who.w '' (scot %p u.who.w))
              tags+a+`(list json)`(turn ~(tap in tags.w) (lead %s))
          ==
      ==
    ::
      :+  'mine'  %a
      ^-  (list json)
      %-  ~(rep by held-wallets)
      ::change remember a cell of 3 things instead of 2.
      ::held-wallets=(map @ux [nick=@t tags=(set @tas)])::put balance here
      |=  [[a=@ux [n=@t t=(set @tas)]] j=(list json)]
      ::|=  a=*
     :_  j  :-  %a
      :~  s+(scot %ux a)
        ::
          %-  pairs
          :~  address+s+(scot %ux a)
              nick+s+n
              tags+a+`(list json)`(turn ~(tap in t) (lead %s))
          ==
      ==
    ==
  --
++  gilt                                                 ::  page helpers
  |%
  ++  zip-zap
    |=  [u=@t p=@t]
    ^-  (quip card _state)
    :_  state(zapper-token [u p])
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs:enjs:format
    ~[head+s+'just-status' status+s+'Etherium.Fi Credentials Updated']
  ++  eth-key
    |=  [k=@t]
    ^-  (quip card _state)
    :_  state(etherscankey k)
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs:enjs:format
    :~  head+s+'etherscan-key'
        key+s+k
        status+s+'Etherscan Credentials Updated'
    ==
  ++  add-dis
    |=  t=transaction
    ^-  (quip card _state)
    ~|  "%books-fail -bad-transaction! {<timestamp.t>}"
    ?~  gat=(get:((on ,[p=@da q=@ux] transaction) gth-hex) transactions [timestamp.t hash.t])
      =.  transactions
        (put:((on ,[p=@da q=@ux] transaction) gth-hex) transactions [timestamp.t hash.t] t)
      :_  state
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
      =,  enjs:format
      %-  pairs
      :~  head+s+'add-transaction'
          status+s+(crip "Added Transaction: {(scow %ux hash.t)}")
          transaction+(transaction:en-json t)
      ==
    ~|  "%worse-news -different-records! {<t>} {<u.gat>}"
    ?>  ?&  =(hash.t hash.u.gat)
            =(nonce.t nonce.u.gat)
        ==
    `state
  ::
  ++  del-wal
    |=  a=@ux
    ^-  (quip card _state)
    ~|  '%books-fail -address-not-tracked'
    ?>  (~(has by held-wallets) a)
    =.  held-wallets  (~(del by held-wallets) a)
    =/  c  (crip ['0' 'x' ((x-co:co (met 3 a)) a)])
    =.  wallet-states  (~(del by wallet-states) c)
    =,  enjs:format
    :_  state
    :-  (del-trans:uber)
    :::-  (del-balance:uber)
    :-  (del-nft:uber)
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs
    :~  head+s+'del-wallet'
        remove+s+(scot %ux a)
        status+s+(crip "Deleted Tracked Wallet: {(scow %ux a)}")
    ==
    ::
  ++  add-wal
    |=  [a=@ux n=@t t=(set @tas)]
    ^-  (quip card _state)
    ~|  '%books-fail -address-already-tracked'
    ?<  (~(has by held-wallets) a)
    =.  held-wallets
      (~(put by held-wallets) a [n t])
    =,  enjs:format
    :_  state
    :::-  (zapper-fi:uber /some)
    :-  (get-trans:uber)
    :-  (get-balance:uber)
    :-  (get-nft:uber)
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs:enjs:format
    :~  head+s+'add-wallet'
      :-  'new'
      :-  %a
      :~  s+(scot %ux a)
        ::
          %-  pairs
          :~  nick+s+n
              tags+a+`(list json)`(turn ~(tap in t) (lead %s))
          ==
      ==
    ::
      status+s+(crip "Added Tracked Wallet: {(scow %ux a)}")
    ==
  ::
  ++  add-bud
    |=  [a=@ux w=wallet]
    :_  state(lilblackbook (~(put by lilblackbook) a w))
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    =,  enjs:format
    %-  pairs
    :~  head+s+'add-friend'
        status+s+(crip "Added Friend: {(scow %uw a)}")
        :+  %new  %a
        :~  s+(scot %ux a)
            %-  pairs
            :~  nick+s+nick.w
                who+?~(who.w ~ s+(scot %p u.who.w))
                :+  %tags  %a
                %~  tap  in  ^-  (set json)
                (~(run in tags.w) |=(a=@tas `json`s+(scot %tas a)))
            ==
        ==  
    ==
  ++  del-bud
    |=  [a=@ux]
    :_  state(lilblackbook (~(del by lilblackbook) a))
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs:enjs:format
    :~  head+s+'del-friend'
        remove+s+(scot %ux a)
        status+s+(crip "Deleted Friend Info: {(scow %ux a)}")
    ==
  ::
  ++  pen-pad
    |=  [h=@ux n=annotation]
    ^-  (quip card _state)
    :_  state(elucidations (~(put by elucidations) h n))
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs:enjs:format
    :~  head+s+'annotation'
        status+s+(crip "New Annotation For: {(scow %ux h)}")
      ::
      :+  'new'  %a
      :~  %-  pairs:enjs:format
          :~  hash+s+(scot %ux h)
              basis+s+(scot %rd basis.n)
              to+?~(to.n ~ s+(scot %ux u.to.n))
              annotation+s+annotation.n
              tags+a+(turn ~(tap in tags.n) (lead %s))
          ==
      ==
    ==
  ++  rub-rub
    |=  h=@ux
    ^-  (quip card _state)
    =.  elucidations
      (~(del by elucidations) h)
    :_  state
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs:enjs:format
    :~  head+s+'del-a-note'
        status+s+(crip "Deleted Annotation For: {(scow %ux h)}")
        remove+s+(scot %ux h)
    ==
  ++  mah-guy
    |=  [a=@ux p=(unit @p)]
    ^-  (quip card _state)
    ~|  '%books-fail -no-such-friend'
    ?>  (~(has by lilblackbook) a)
    =+  old=(~(got by lilblackbook) a)
    =.  lilblackbook
      (~(put by lilblackbook) a old(who p))
    :_  state
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs:enjs:format
    :~  head+s+'add-friend'
        status+s+(crip "Updated Friend: {(scow %ux a)}")
    ::
      :+  'new'  %a
      :~  s+(scot %ux a)
        %-  pairs:enjs:format
        :~  nick+s+nick.old
            who+?~(p ~ s+(scot %p u.p))
            tags+a+`(list json)`(turn ~(tap in tags.old) (lead %s))
        ==
      ==
    ==
  ++  nic-nam
    |=  [a=@ux n=@t]
    ^-  (quip card _state)
    ~|  '%books-fail -no-such-wallet'
    ?>  |((~(has by held-wallets) a) (~(has by lilblackbook) a))
    ?:  (~(has by lilblackbook) a)
      =+  old=(~(got by lilblackbook) a)
      =.  lilblackbook
        (~(put by lilblackbook) a old(nick n))
      :_  state
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
      %-  pairs:enjs:format
      :~  head+s+'add-friend'
          status+s+(crip "Updated Friend: {(scow %ux a)}")
      ::
        :+  'new'  %a
        :~  s+(scot %ux a)
        ::
          %-  pairs:enjs:format
          :~  nick+s+n
              who+?~(who.old ~ s+(scot %p u.who.old))
              tags+a+`(list json)`(turn ~(tap in tags.old) (lead %s))
          ==
        ==
      ==
    =+  old=(~(got by held-wallets) a)
    =.  held-wallets
      (~(put by held-wallets) a old(nick n))
    :_  state
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs:enjs:format
    :~  head+s+'add-wallet'
        status+s+(crip "Updated Wallet: {(scow %ux a)}")
      ::
      :+  'new'  %a
      :~  s+(scot %ux a)
      ::
        %-  pairs:enjs:format
        ~[nick+s+n tags+a+`(list json)`(turn ~(tap in tags.old) (lead %s))]
      ==
    ==
  ++  tag-man
    |=  [a=@ux t=(set @tas)]
    ^-  (quip card _state)
    ~|  '%books-fail -no-such-wallet'
    ?>  |((~(has by held-wallets) a) (~(has by lilblackbook) a))
    ?:  (~(has by lilblackbook) a)
      =+  old=(~(got by lilblackbook) a)
      =.  lilblackbook
        (~(put by lilblackbook) a old(tags t))
      :_  state
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
      %-  pairs:enjs:format
      :~  head+s+'add-friend'
          status+s+(crip "Updated Friend: {(scow %ux a)}")
        ::
        :+  'new'  %a
        :~  s+(scot %ux a)
          ::
            %-  pairs:enjs:format
            :~  nick+s+nick.old
                who+?~(who.old ~ s+(scot %p u.who.old))
              tags+a+`(list json)`(turn ~(tap in t) (lead %s))
            ==
        ==
      ==
      ::
    =+  old=(~(got by held-wallets) a)
    =.  held-wallets
      (~(put by held-wallets) a old(tags t))
    :_  state
    =-  [%give %fact ~[/website] json+!>(`json`-)]~
    %-  pairs:enjs:format
    :~  head+s+'add-wallet'
        status+s+(crip "Updated Wallet: {(scow %ux a)}")
      ::
      :+  'new'  %a
      :~  s+(scot %ux a)
        ::
          %-  pairs:enjs:format
          :~  nick+s+nick.old
            tags+a+`(list json)`(turn ~(tap in t) (lead %s))
          ==
      ==
    ==
    ::update/refresh all api's
  ++  up-date
      ^-  (quip card _state)
      =,  enjs:format
      :_  state
      :::-  (zapper-fi:uber /some)
      :-  (get-trans:uber)
      :-  (get-balance:uber)
      :-  (get-nft:uber)
      =-  [%give %fact ~[/website] json+!>(`json`-)]~
      %-  pairs:enjs:format
      :~  head+s+'books updated on'
          status+s+`@t`(scot %da now.bol)
      ==
  --
  ++  en-json
    =,  enjs:format
    |%
    ++  transactions
      |=  t=_^transactions
      %+  turn
        (tap:((on ,[@da @ux] ^transaction) gth-hex) t)
      |=  [[@da @ux] p=^transaction]
      (transaction p)

    ++  transaction
      |=  t=^transaction
      ^-  json
      %-  pairs
      :~  primarywallet+s+(scot %ux primarywallet.t)
          ::network+s+network.t
          hash+s+(scot %ux hash.t)
          blocknumber+(numb blocknumber.t)
          name+s+name.t
          ::direction+s+direction.t
          timestamp+(sect timestamp.t)
          ::symbol+s+symbol.t
          address+?~(address.t ~ s+(scot %ux u.address.t))
          amount+s+(cut 3 [2 (lent (scow %rd amount.t))] (scot %rd amount.t))
          from+s+(scot %ux from.t)
          destination+s+(scot %ux destination.t)
          contract+?~(contract.t ~ s+(scot %ux u.contract.t))
          nonce+(numb nonce.t)
        ::
          :-  'txgas'
          ?~  txgas.t  ~
          s+(cut 3 [2 (lent (scow %rd u.txgas.t))] (scot %rd u.txgas.t))
          :-  'txgaslimit'
          ?~  txgaslimit.t  ~
          s+(cut 3 [2 (lent (scow %rd u.txgaslimit.t))] (scot %rd u.txgaslimit.t))
        ::
          input+?~(input.t ~ s+u.input.t)
          fee+s+(cut 3 [2 (lent (scow %rd fee.t))] (scot %rd fee.t))
          txsuccessful+b+txsuccessful.t
      ==
    ++  enjsonbalance
   |=  n=(map walletaddress=@t balance=@ud)
    =/  listn  ~(tap by n)  :: Extract the key-value pairs from the map `n`
    :-  %a
    %+  turn
    listn
    |=  [walletaddress=@t balance=@ud]
    %-  pairs:enjs:format
    :~  walletaddress+s+walletaddress
        balance+s+(scot %ud balance)
    ==
    ++  enjsonnft
   |=  n=(map blocknumber=@t [timestamp=@t hash=@t from=@t to=@t tokenid=@t tokenname=@t tokensymbol=@t gas=@t])
    =/  listn  ~(tap by n)  :: Extract the key-value pairs from the map `n`
    :-  %a
    %+  turn
    listn
    |=  [blocknumber=@t [timestamp=@t hash=@t from=@t to=@t tokenid=@t tokenname=@t tokensymbol=@t gas=@t]]
    %-  pairs:enjs:format
    :~  blocknumber+s+blocknumber
        timestamp+s+timestamp
        hash+s+hash
        from+s+from
        to+s+to
        tokenid+s+tokenid
        tokenname+s+tokenname
        tokensymbol+s+tokensymbol
        gas+s+gas
    ==
     ++  enjsontrans
   |=  n=(map timestamp=@t [hash=@t from=@t to=@t value=@t gas=@t gasused=@t])
    =/  listn  ~(tap by n)  :: Extract the key-value pairs from the map `n`
    :-  %a
    %+  turn
    listn
    |=  [timestamp=@t [hash=@t from=@t to=@t value=@t gas=@t gasused=@t]]
    %-  pairs:enjs:format
    :~  timestamp+s+timestamp
        hash+s+hash
        from+s+from
        to+s+to
        value+s+value
        gas+s+gas
        gasused+s+gasused
    ==
    --
--