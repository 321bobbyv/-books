import { createRouter, createWebHistory, RouteRecordRaw } from "vue-router";
import WalletList from "@/components/WalletList.vue";
import FriendList from "@/components/FriendList.vue";
import TransactionList from "@/components/TransactionList.vue";
import Home from "@/views/Home.vue";
//import EthTransactionList from "@/components/EthTransDetails.vue";
//import NftTransactionList from "@/components/NftTransDetails.vue";
const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "home",
    component: Home,
  },
  {
    path: "/wallets",
    name: "wallets",
    component: () => import("@/components/WalletList.vue"), // Lazy-loaded
  },
  {
    path: "/transactions",
    name: "transactions",
    component: () => import("@/components/TransactionList.vue"), // Lazy-loaded
  },
  {
    path: "/ethtransactions",
    name: "ethtransactions",
    component: () => import("@/components/EthTransactionList.vue"), // Lazy-loaded
  },
  {
    path: "/nfttransactions",
    name: "nfttransactions",
    component: () => import("@/components/NftTransactionList.vue"), // Lazy-loaded
  },
  {
    path: "/rolodex",
    name: "rolodex",
    component: () => import("@/components/FriendList.vue"), // Lazy-loaded
  },
  {
    path: "/:catchAll(.*)",
    name: "not-found",
    component: () => import("@/views/NotFound.vue"), // 404 Page
  },
];

const router = createRouter({
  history: createWebHistory("/apps/books/"),
  routes,
});

export default router;
