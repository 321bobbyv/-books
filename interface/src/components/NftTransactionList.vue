<template>
    <a-table
      :columns="columns"
      :data-source="data"
      :scroll="{ x: 1000 }"
      expand-row-by-click
      :loading="awaitingUrbitData"
    >
    <template #expandedRowRender="{ record }">
      <div class="flex">
        <div class="flex-auto basis-1/2">
          <NftTransDetails
            :blocknumber="record.blocknumber"
            :timestamp="record.timeStamp"
            :hash="record.hash"
            :from="record.from"
            :to="record.to"
            :tokenid="record.tokenid"
            :tokenname="record.tokenname"
            :tokensymbol="record.tokensymbol"
            :gas="record.gas"
          />
        </div>
        <div class="flex-auto basis-1/2">
          <Note :hash="record.hash" />
        </div>
      </div>
    </template>
  </a-table>
</template>

// AR - delete or read in.
<script lang="ts">
import { Decimal } from "decimal.js";
import { FormOutlined } from "@ant-design/icons-vue";
import Note from "@/components/Note.vue";
import { useStore } from "vuex";
import dateFormat, { masks } from "dateformat";
import AddressLookup from "@/components/AddressLookup.vue";
import TransDetails from "@/components/TransDetails.vue";
import { computed, defineComponent } from "vue";
import dateFormat, { masks } from "dateformat";
import Immutable from "immutable";
import { Address, Transaction } from "@/types";
import { Note as ANote } from "@/types";

type FlowDirection = string;
type FlowAmount = string;
type FlowCurrency = string;
type Steps = [FlowDirection, FlowAmount, FlowCurrency];
//
export default defineComponent({
  setup() {
    //  boiler
    const store = useStore();

    //  mapState and mapGetters replacements
    const orderedTransactions = computed(
      () => store.getters["books/orderedTransactions"]
    );
    const myWallets = computed(() => store.state.books.myWallets);
    const myFriends = computed(() => store.state.books.myFriends);
    const notes = computed(() => store.state.books.notes);
    const urbitnfttransData = computed(() => store.state.books.urbitnfttransData);

    const awaitingUrbitData = computed(
      () => store.state.books.awaitingUrbitData
    );
    //  mounted-actions
    store.dispatch("books/handleSwitchNav", 2);
    
    // Return all reactive properties for template use
    return {
      orderedTransactions,
      myWallets,
      myFriends,
      notes,
      urbitnfttransData,
      awaitingUrbitData
    };
  }
});
</script>
