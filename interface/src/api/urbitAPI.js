// import UrbitInterface from "@urbit/http-api"; // for typescript
import connector from "@urbit/http-api";
//This imports the connector function or class from the @urbit/http-api package, which is a library used to communicate with an Urbit ship over HTTP.
const urbitAPI = new connector("", "");
urbitAPI.ship = window.ship;
//The urbitAPI object has a ship property that is being assigned to window.ship. This means the ship information is stored somewhere in the global window object.
export default urbitAPI;
//Finally, the urbitAPI instance is exported as the default export so it can be imported and used in other parts of the application.