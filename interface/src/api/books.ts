import urbitAPI from "./urbitAPI";
import { Scry } from "@urbit/http-api";
import { Transaction, Address, TxHash } from "@/types";
import Decimal from "decimal.js";
//urbitAPI: This is the API module to interact with Urbit, used to send pokes.
//Scry: A specific method from the Urbit HTTP API, though it’s not used in this file.
//Types (Transaction, Address, TxHash): Custom types to ensure proper typing for addresses, transaction hashes, and entire transactions.
//Decimal: A library for working with precise decimal arithmetic, often needed when handling financial data (e.g., cryptocurrency transactions).

export function arrayAndHepTags(tags: string): Array<string> {
  const regex = /\s+/g;
  return tags
    .split(",")
    .slice()
    .map((tag) => tag.trim().replace(regex, "-").toLowerCase());
}
//This function takes a comma-separated string of tags, removes whitespace, replaces spaces within tags with dashes (-), and converts them to lowercase.
//Purpose: Normalizes and processes tags before sending them to the Urbit backend.
export function concatOldTagsNewTagString(
  oldTags: Array<string>,
  newTagString: string
): Array<string> {
  return oldTags.slice().concat(arrayAndHepTags(newTagString));
}
//This function combines an existing array of tags (oldTags) with new tags from a string (newTagString), using arrayAndHepTags to process the new tags.
//Purpose: Allows adding new tags to an existing tag list in a formatted way.
export function pushWallet(
  address: Address,
  nick: string,
  tags: Array<string>
) {
  return urbitAPI.poke({
    //   return {
    app: "books",
    mark: "books-page",
    json: {
      "add-wallet": {
        address: address.toLowerCase(),
        nick: nick,
        tags: tags,
      },
    },
    //   }
  });
}
//Purpose: Adds a new wallet by sending a poke with the address, a nickname for the wallet, and associated tags to the Urbit backend.
export function pullWallet(address: Address) {
  return urbitAPI
    .poke({
      app: "books",
      mark: "books-page",
      json: { "del-wallet": { address } },
    })
    .then((r) => {
      return r;
    })
    .catch((e) => {
      console.log("err ", e);
    });
}
//Purpose: Removes a wallet with the given address by sending a poke to delete it.
//Error handling is included but minimal, simply logging the error if something goes wrong.
export function pushFriend(
  address: Address,
  nick: string,
  who: string,
  tags: Array<string>
) {
  return urbitAPI.poke({
    app: "books",
    mark: "books-page",
    json: {
      "add-friend": {
        address: address.toLowerCase(),
        nick: nick,
        who: who,
        tags: tags,
      },
    },
  });
}
//Purpose: Deletes a friend with the given address, similar to how pullWallet works.
//Uses poke with json: { "del-friend": { address } } to remove a friend.
export function pullFriend(address: Address) {
  return urbitAPI
    .poke({
      app: "books",
      mark: "books-page",
      json: { "del-friend": { address } },
    })
    .then((r) => {
      return r;
    })
    .catch((e) => {
      console.log("err ", e);
    });
}
//Purpose: Sets or updates the tags for a given wallet address.
export function pushTags(address: Address, tags: Array<string>) {
  return urbitAPI.poke({
    app: "books",
    mark: "books-page",
    json: { "set-tags": { address: address, tags: tags } },
  });
}
//Purpose: Sets or updates the nickname for a wallet or friend identified by the given address.
export function pushName(address: Address, name: string) {
  return urbitAPI.poke({
    app: "books",
    mark: "books-page",
    json: { "set-nick": { address: address, nick: name } },
  });
}
//Purpose: Adds an annotation to a transaction, identified by its hash, with metadata like basis (Decimal), recipient address (to), the annotation message, and associated tags.
export function pushAnnotation(
  hash: TxHash,
  note: {
    basis: Decimal;
    to: Address | null;
    annotation: string;
    tags: Array<string>;
  }
) {
  return urbitAPI.poke({
    app: "books",
    mark: "books-page",
    json: { annotation: { hash: hash, note: note } },
  });
}
//Purpose: Adds a transaction to the Urbit books app. The Transaction object is reformatted, and decimal numbers are converted to strings before sending it to Urbit.
export function pushTransaction(trans: Transaction) {
  const reformTrans = {
    network: trans.network,
    hash: trans.hash,
    blocknumber: trans.blockNumber,
    name: trans.name,
    direction: trans.direction,
    timestamp: trans.timeStamp,
    symbol: trans.symbol,
    address: trans.address,
    amount: trans.amount.toString(),
    from: trans.from,
    destination: trans.destination,
    contract: trans.contract,
    subtransactions: trans.subTransactions.map((subt) => {
      return {
        address: subt.address,
        amount: subt.amount.toString(),
        symbol: subt.symbol,
        type: subt.type,
      };
    }),
    nonce: trans.nonce,
    txgas: trans.txGas?.toString(),
    txgaslimit: trans.txGasLimit?.toString(),
    input: trans.input,
    fee: trans.fee.toString(),
    txsuccessful: trans.txSuccessful,
    primarywallet: trans.primaryWallet,
  };
  console.log(reformTrans);
  urbitAPI
    .poke({
      //   return {
      app: "books",
      mark: "books-page",
      json: { "add-transaction": reformTrans },
      //   }
    })
    .then((r) => {
      console.log("res ", r);
    })
    .catch((e) => {
      console.log(reformTrans);
      console.log("err ", e);
    });
}
