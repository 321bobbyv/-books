import urbitAPI from "./urbitAPI";
//This imports the urbitAPI object, which is likely responsible for communicating with an Urbit ship
interface onSubNumber {
  (subNumber: number): void;
}
//This function subscribes to an event stream for a given agent (app) and processes events related to the Urbit system. 
//It handles the subscription and triggers event callbacks when events occur.
export function openAirlockTo(
  agent: string,
  onEvent,
  onSubNumber: onSubNumber
) {
  urbitAPI
    .subscribe({
      app: agent,
      path: "/website",
      event: (data) => {
        onEvent(data);
      },
    })
    .then((sub: number) => {
      onSubNumber(sub);
    });
}
//This function unsubscribes from an existing subscription using the subscription number provided, 
//effectively closing the airlock (the connection to Urbit events).
export function closeAirlock(subscription: number, onClose) {
  urbitAPI.unsubscribe(subscription).then(() => {
    onClose;
  });
}
