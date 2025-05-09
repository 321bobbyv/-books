//This code merges the contents of urbitAPI and airlock into a new object using the spread operator (...).
//...urbitAPI spreads all properties from the urbitAPI object into the new object.
//...airlock spreads all properties from the airlock object into the same new object.
//The result is that the combined object is exported as the default from this module.
import urbitAPI from "./urbitAPI";
//The code imports the default export from urbitAPI.js using import urbitAPI from "./urbitAPI". This means urbitAPI.js exports either an object, function, or class as the default.
import * as airlock from "./airlock";
// It also imports all the exports from airlock.js as an object called airlock with the syntax import * as airlock from "./airlock". This will bundle all named exports from airlock.js into a single object.
export default {
  ...urbitAPI,
  ...airlock,
};