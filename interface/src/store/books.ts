//The books.ts file is a Vuex module that manages the state, mutations, 
//actions, and getters related to "books" in the context of your Vue.js application. Let's break down its main components:
import {
  Transaction,
  NftTransactions,
  EthTransactions,
  WalletStates,
  Navi,
  Note,
  Address,
  TxHash,
  WalletDetails,
  Annotation,
  EthTransaction,
} from "@/types";
import Immutable, { OrderedMap } from "immutable";
import { EthSubscription } from "web3";

export default {
  namespaced: true,
  state() {
    return {
      //  loading state
      hasUrbitSubscription: false as Boolean,
//The state function returns an object that contains various properties related to transactions, 
//wallets, friends, and UI states (e.g., navigation and loading indicators). Here's a breakdown:
      //  state objects
      etherscanKey: "3NJSFSVR8PZRN6CTIIXERD88YBKCIXXMW7",
      havUrbData: false as boolean,
      awaitingUrbitData: false as boolean,
      urbitData: [] as Array<[[number, TxHash], Transaction]>,
      urbitnfttransData: [] as Array<[NftTransactions]>,
      urbitethtransData: [] as Array<[EthTransactions]>,
      urbitwalletstatesData: [] as Array<[WalletStates]>,
      notes: [] as Array<[TxHash, Note]>,
      myFriends: [] as Array<[Address, WalletDetails]>,
      myWallets: [] as Array<[Address, { nick: string; tags: Array<string> }]>,
      walletStates: [] as Array<[Address, { balance: string}]>,
      nav: 0 as Navi,
      transPage: 0 as number,
      browsing: "" as Address,
    };
  },
//urbitData: Stores transaction data received from Urbit.
//notes: Stores notes or annotations associated with transactions.
//myFriends: Contains details about user-defined friends (addresses and wallet details).
//myWallets: Contains details about the user's wallets (nicknames and tags).
//walletStates is the user wallet and balance
//urbitnfttransdata is the nft transactions for each wallet
//urbitethtranData is the eth transactions from the etherscan api for each user wallet
//nav, transPage, browsing: Manage UI states such as current navigation tab, transaction pagination, and currently browsed wallet address.
getters: {
    friends(state): Array<string> {
      return ["test"];
    },
//Getters are used to retrieve and process state data. In this case, the module defines two main getters:
//friends: Returns a static test value (likely a placeholder).
//pageFrontTransactions: Returns the first 4 sorted transactions (from orderedTransactions).
//orderedTransactions: Sorts the transactions by timeStamp and hash, either globally or for a specific wallet if browsing is active.
    pageFrontTransactions: (state, getters) => {
      const sorted = getters.orderedTransactions;
      return sorted.slice(1, 5) as Array<[[number, TxHash], Transaction]>;
    },

    pageFrontEthTransactions: (state, getters) => {
      const sorted = getters.orderedEthTransactions;
      return sorted.slice(1, 0) as Array<[[number, TxHash], EthTransaction]>;
    },

    orderedTransactions(state): Array<[[number, TxHash], Transaction]> {
      const immuMap = Immutable.OrderedMap(state.urbitData) as OrderedMap<
        [number, TxHash],
        Transaction
      >;

      if (state.browsing === "") {
        return immuMap
          .sort((a: Transaction, b: Transaction) => {
            if (a.timeStamp > b.timeStamp) {
              return -1;
            }
            if (a.timeStamp < b.timeStamp) {
              return 1;
            }
            if (a.timeStamp == b.timeStamp) {
              if (a.hash > b.hash) {
                return -1;
              }
              if (a.hash < b.hash) {
                return 1;
              } else {
                return 0;
              }
            } else {
              return 0;
            }
          })
          .toArray() as Array<[[number, TxHash], Transaction]>;
      } else {
        const filtMap = Immutable.OrderedMap(
          state.urbitData.filter((a) => {
            if (a[1].primaryWallet === state.browsing) {
              return true;
            } else {
              return false;
            }
          })
        ) as OrderedMap<[number, TxHash], Transaction>;

        return filtMap
          .sort((a: Transaction, b: Transaction) => {
            if (a.timeStamp > b.timeStamp) {
              return -1;
            }
            if (a.timeStamp < b.timeStamp) {
              return 1;
            }
            if (a.timeStamp == b.timeStamp) {
              if (a.hash > b.hash) {
                return -1;
              }
              if (a.hash < b.hash) {
                return 1;
              } else {
                return 0;
              }
            } else {
              return 0;
            }
          })
          .toArray() as Array<[[number, TxHash], Transaction]>;
      }
    },
    orderedEthTransactions(state): Array<[[number, TxHash], EthTransaction]> {
      const immuMap = Immutable.OrderedMap(state.urbitData) as OrderedMap<
        [number, TxHash],
        EthTransaction
      >;

      if (state.browsing === "") {
        return immuMap
          .sort((a: EthTransaction, b: EthTransaction) => {
            if (a.timestamp > b.timestamp) {
              return -1;
            }
            if (a.timestamp < b.timestamp) {
              return 1;
            }
            if (a.timestamp == b.timestamp) {
              if (a.hash > b.hash) {
                return -1;
              }
              if (a.hash < b.hash) {
                return 1;
              } else {
                return 0;
              }
            } else {
              return 0;
            }
          })
          .toArray() as Array<[[number, TxHash], EthTransaction]>;
      } else {
        const filtMap = Immutable.OrderedMap(
          state.urbitData.filter((a) => {
            if (a[1].primaryWallet === state.browsing) {
              return true;
            } else {
              return false;
            }
          })
        ) as OrderedMap<[number, TxHash], EthTransaction>;

        return filtMap
          .sort((a: EthTransaction, b: EthTransaction) => {
            if (a.timestamp > b.timestamp) {
              return -1;
            }
            if (a.timestamp < b.timestamp) {
              return 1;
            }
            if (a.timestamp == b.timestamp) {
              if (a.hash > b.hash) {
                return -1;
              }
              if (a.hash < b.hash) {
                return 1;
              } else {
                return 0;
              }
            } else {
              return 0;
            }
          })
          .toArray() as Array<[[number, TxHash], EthTransaction]>;
      }
    },
  },
//
  
//Mutations are synchronous methods that directly modify the state.
  mutations: {
    setBrowse(state, which) {
      console.log("wallet: ", which);
      state.browsing = which;
    },

    setTransPage(state, which) {
      console.log("page: ", which);
      state.transPage = which;
    },

    setEthTransPage(state, which) {
      console.log("ethpage: ", which);
      state.ethtransPage = which;
    },

    setNftTransPage(state, which) {
      console.log("nftpage: ", which);
      state.nfttransPage = which;
    },

    setNav(state, which) {
      console.log("tab: ", which);
      state.nav = which;
    },

    setWallets(
      state,
      battery: {
        fren: Array<[Address, WalletDetails]>;
        mine: Array<[Address, { nickname: string; tags: Array<string> }]>;
      }
    ) {
      console.log("setting my-wallets: ", battery.mine);
      state.myWallets = Immutable.Map(state.myWallets)
        .mergeDeepWith((olds, news) => {
          return news;
        }, Immutable.Map(battery.mine))
        .toArray();
      console.log("setting fren-wallets: ", battery.fren);
      state.myFriends = Immutable.Map(state.myFriends)
        .mergeDeepWith((olds, news) => {
          return news;
        }, Immutable.Map(battery.fren))
        .toArray();
    },

    setTransactions(
      state,
      battery: {
        tran: Array<Transaction>;
      }
    ) {
      console.log("set-transaction");
      const newt = battery.tran
        .slice()
        .map((t) => [[t.timeStamp, t.hash], t]) as Array<
        [[number, TxHash], Transaction]
      >;
      state.urbitData = state.urbitData.concat(
        newt.filter((item) => {
          return !Immutable.Map(state.urbitData).has(item[0]);
        })
      );
    },
 
    unSetTransactions(
      state,
      battery: {
        tran: Array<Transaction>;
      }
    ) {
      console.log("unset-transaction");
      const newt = battery.tran
        .slice()
        .map((t) => [[t.timeStamp, t.hash], t]) as Array<
        [[number, TxHash], Transaction]
      >;
      state.urbitData = newt;
    },
    setAnnotations(
      state,
      battery: {
        notes: Array<[TxHash, Annotation]>;
      }
    ) {
      console.log("set-annotation");
      state.notes = battery.notes.concat(
        state.notes.filter((item) => {
          return !Immutable.Map(battery.notes).has(item[0]);
        })
      );
    },

    addWallet(
      state,
      battery: {
        new: [Address, { nickname: string; tags: Array<string> }];
      }
    ) {
      console.log("add-wallet", battery.new[0]);
      state.myWallets = Immutable.Map(state.myWallets)
        .delete(battery.new[0])
        .set(battery.new[0], battery.new[1])
        .toArray();
    },

    delWallet(
      state,
      battery: {
        remove: Address;
      }
    ) {
      console.log("del-wallet", battery.remove);
      state.myWallets = Immutable.Map(state.myWallets)
        .delete(battery.remove)
        .toArray();
    },

    addFriend(
      state,
      battery: {
        new: [Address, WalletDetails];
      }
    ) {
      console.log("add-friend", battery.new[0]);
      state.myFriends = Immutable.Map(state.myFriends)
        .delete(battery.new[0])
        .set(battery.new[0], battery.new[1])
        .toArray();
    },

    delFriend(
      state,
      battery: {
        remove: Address;
      }
    ) {
      console.log("del-friend", battery.remove);
      state.myFriends = Immutable.Map(state.myFriends)
        .delete(battery.remove)
        .toArray();
    },

    addTransaction(
      state,
      battery: {
        trans: Transaction;
      }
    ) {
      console.log("add-Transaction", battery.trans);
      state.urbitData = Immutable.OrderedMap(state.urbitData)
        .mergeDeepWith((olds, news) => {
          return news;
        }, Immutable.OrderedMap([[[battery.trans.timeStamp, battery.trans.hash], battery.trans]]))
        .toArray();
    },
    setAwaitingUrbitData(state, waiting: boolean) {
      console.log("waiting ", waiting);
      state.awaitingUrbitData = waiting;
    },
    setHavUrbData(state, hav: boolean) {
      state.havUrbData = hav;
    },
  },
//Actions handle asynchronous logic and commit mutations to update the state. Here's what they do:
  actions: {
    startAwaitingUrbitData({ commit }) {
      commit("setAwaitingUrbitData", true);
      commit("setHavUrbData", false);
    },
    stopAwaitingUrbitData({ commit }) {
      commit("setAwaitingUrbitData", false);
      commit("setHavUrbData", true);
    },

    handleSwitchPage({ commit }, battery: number) {
      commit("setTransPage", battery);
    },

    handleSwitchBrowse({ commit }, battery: string) {
      commit("setBrowse", battery);
    },

    handleSwitchNav({ commit }, battery: Navi) {
      commit("setNav", battery);
    },

    handleSetWallets(
      { commit },
      battery: {
        fren: Array<[Address, WalletDetails]>;
        mine: Array<[Address, { nickname: string; tags: Array<string> }]>;
      }
    ) {
      commit("setWallets", { fren: battery.fren, mine: battery.mine });
    },
    handleSetAnnotation({ commit }, battery: { notes: Array<[TxHash, Note]> }) {
      console.log("battery", battery.notes);
      commit("setAnnotations", { notes: battery.notes });
    },
    handleSetTransactions(
      { state, commit, dispatch },
      battery: {
        tran: Array<Transaction>;
      }
    ) {
      console.log("battery", battery.tran);
      dispatch("stopAwaitingUrbitData");
      commit("setTransactions", { tran: battery.tran });
    },
    handleUnSetTransactions(
      { commit },
      battery: {
        tran: Array<Transaction>;
      }
    ) {
      console.log("unsetting", battery.tran);
      commit("unSetTransactions", { tran: battery.tran });
    },
    handleSetethTransactions(
      { state, commit, dispatch },
      battery: {
        tran: Array<Transaction>;
      }
    ) {
      console.log("battery", battery.tran);
      dispatch("stopAwaitingUrbitData");
      commit("setTransactions", { tran: battery.tran });
    },
    handleUnSetethTransactions(
      { commit },
      battery: {
        tran: Array<Transaction>;
      }
    ) {
      console.log("unsetting", battery.tran);
      commit("unSetTransactions", { tran: battery.tran });
    },
    handleSetnftTransactions(
      { state, commit, dispatch },
      battery: {
        tran: Array<Transaction>;
      }
    ) {
      console.log("battery", battery.tran);
      dispatch("stopAwaitingUrbitData");
      commit("setTransactions", { tran: battery.tran });
    },
    handleUnSetnftTransactions(
      { commit },
      battery: {
        tran: Array<Transaction>;
      }
    ) {
      console.log("unsetting", battery.tran);
      commit("unSetTransactions", { tran: battery.tran });
    },
    handleAddWallet(
      { commit },
      battery: {
        new: [Address, { nickname: string; tags: Array<string> }];
      }
    ) {
      commit("addWallet", { new: battery.new });
    },
    handleDelWallet({ commit }, battery: { remove: Address }) {
      commit("delWallet", { remove: battery.remove });
    },
    handleAddFriend(
      { commit },
      battery: {
        new: [Address, WalletDetails];
      }
    ) {
      commit("addFriend", { new: battery.new });
    },
    handleDelFriend({ commit }, battery: { remove: Address }) {
      commit("delFriend", { remove: battery.remove });
    },
    handleAddTransaction({ commit }, battery: { transaction: Transaction }) {
      commit("addTransaction", { trans: battery.transaction });
    },
    // handleAddNote(
    //   { commit }
    // )
  },
};
