This project is a web-based interface for managing and tracking cryptocurrency wallets and transactions, with a specific focus on Ethereum. It interacts with an Urbit backend for data storage and real-time updates.

Here's a breakdown of its main components and features:

*   **Frontend:** The application is built using the **Vue.js** framework, with **Vuex** for state management and **Ant Design Vue** for UI components. The main entry point is `interface/src/main.js`.
*   **Backend:** It uses **Urbit** as its backend. The `interface/src/store/ship.ts` and `interface/src/api/` files show that it uses Urbit's `airlock` library for real-time communication and data synchronization.
*   **Core Functionality:** The main application logic is in `interface/src/store/books.ts`. This Vuex module manages the application's state, including:
    *   **Wallet Management:** Users can add, delete, and manage their own Ethereum wallets and track the wallets of friends.
    *   **Transaction Tracking:** The interface displays a list of transactions, including both ETH and NFT transfers. It also fetches data from the Etherscan API, as indicated by the `etherscanKey` in `books.ts`.
    *   **Annotations and Tagging:** Users can add notes and tags to transactions for better organization.
*   **Views and Components:**
    *   `interface/src/views/Home_eth.vue`: The main dashboard that displays tracked wallets and recent transactions.
    *   `interface/src/components/EthTransactionList.vue`: A component that renders a detailed list of Ethereum transactions.

In summary, this project is a cryptocurrency portfolio tracker with social features, using Urbit for its backend infrastructure.

Based on the project structure, here is where you would place your backend integration code and how you would connect it to your components.

### 1. Where to Place Backend API Code

Your core backend communication logic should reside in the `interface/src/api/` directory.

*   **`interface/src/api/airlock.ts`**: This file is ideal for managing subscriptions and real-time data streams from your Urbit backend. The existing `openAirlockTo` function is a great template for creating new subscriptions.
*   **`interface/src/api/urbitAPI.js`**: If you need to make one-off calls (pokes) to your Urbit ship rather than setting up a persistent subscription, you can add wrapper functions here.
*   **`interface/src/api/index.js`**: This file aggregates all functions from the other API files. Any new functions you export from `airlock.ts` or `urbitAPI.js` should be exported here as well to be accessible throughout the application.

**Example: Adding a new API call**

If you needed to fetch user profile data, you could add a function to `interface/src/api/airlock.ts`:

```typescript
// In interface/src/api/airlock.ts

export function getProfile(onData: (data: any) => void) {
  urbitAPI.scry({ app: 'books', path: '/profiles' }).then(onData);
}
```

Then, you would export it from `interface/src/api/index.js`.

### 2. How to Wire Up Functions to Components

The project uses a **Vuex store** to manage state and interactions. The pattern is to call API functions from Vuex actions and then update the state with mutations. Components then dispatch these actions.

*   **Vuex Actions (`interface/src/store/ship.ts`)**: This is the best place to create actions that call your new API functions. This keeps the API logic separate from the state management of the `books` module. The action you create here can then dispatch another action to the `books` module to update the state.

*   **Vuex Mutations (`interface/src/store/books.ts`)**: The action in `ship.ts` will call an action in `books.ts`, which in turn will `commit` a mutation here to update the state with the data received from the backend.

*   **Vue Components (`interface/src/views/` or `interface/src/components/`)**: To trigger the backend call from a component, you would use `store.dispatch()`. The component would then use a `computed` property to reactively access the updated data from the `books` store.

**Example: Wiring the `getProfile` function**

1.  **Create an action in `interface/src/store/ship.ts`:**

    ```typescript
    // In interface/src/store/ship.ts under actions:
    getProfileData({ dispatch }) {
      airlock.getProfile((data) => {
        dispatch("books/handleSetProfile", data, { root: true });
      });
    }
    ```

2.  **Create a handler action and mutation in `interface/src/store/books.ts`:**

    ```typescript
    // In interface/src/store/books.ts under actions:
    handleSetProfile({ commit }, data) {
      commit("setProfile", data);
    }

    // In interface/src/store/books.ts under mutations:
    setProfile(state, data) {
      state.userProfile = data; // Assuming you added userProfile to the state
    }
    ```

3.  **Dispatch the action from a component:**

    ```typescript
    // In a component's <script> setup
    import { useStore } from "vuex";

    const store = useStore();
    store.dispatch("ship/getProfileData");
    ```

This approach keeps your code organized and follows the established patterns in the project.

Would you like me to generate a template for a new Vue component that follows this pattern?
