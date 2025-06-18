<template>
  <div class="flex flex-col gap-6 p-4">
    <a-card title="Etherscan Settings">
      <a-form
        :model="etherscanFormState"
        @finish="onEtherscanSubmit"
        :label-col="{ span: 6 }"
        :wrapper-col="{ span: 18 }"
      >
        <a-form-item label="Etherscan API Key" name="key">
          <a-input
            v-model:value="etherscanFormState.key"
            placeholder="Enter your Etherscan API key"
          />
        </a-form-item>
        <a-form-item :wrapper-col="{ offset: 6, span: 18 }">
          <a-button type="primary" html-type="submit" :loading="etherscanLoading">
            Update Etherscan Key
          </a-button>
        </a-form-item>
      </a-form>
    </a-card>

    <a-card title="Zapper Credentials">
      <a-form
        :model="zapperFormState"
        @finish="onZapperSubmit"
        :label-col="{ span: 6 }"
        :wrapper-col="{ span: 18 }"
      >
        <a-form-item label="Zapper UID" name="uid">
          <a-input v-model:value="zapperFormState.uid" placeholder="Enter your Zapper UID" />
        </a-form-item>
        <a-form-item label="Zapper Password" name="password">
          <a-input-password
            v-model:value="zapperFormState.password"
            placeholder="Enter your Zapper password"
          />
        </a-form-item>
        <a-form-item :wrapper-col="{ offset: 6, span: 18 }">
          <a-button type="primary" html-type="submit" :loading="zapperLoading">
            Update Zapper Credentials
          </a-button>
        </a-form-item>
      </a-form>
    </a-card>
  </div>
</template>

<script lang="ts">
import { defineComponent, reactive, ref, computed } from "vue";
import { useStore } from "vuex";
import { Form, message } from "ant-design-vue";
import { pushEtherscanKey, pushZapperCreds } from "@/api/books";

export default defineComponent({
  setup() {
    const store = useStore();
    const etherscanLoading = ref(false);
    const zapperLoading = ref(false);

    // Etherscan Form State
    const etherscanKey = computed(() => store.state.books.etherscanKey);
    const etherscanFormState = reactive({
      key: etherscanKey.value || "",
    });

    const onEtherscanSubmit = () => {
      etherscanLoading.value = true;
      pushEtherscanKey(etherscanFormState.key)
        .then(() => {
          message.success("Etherscan key updated successfully.");
        })
        .catch((err) => {
          message.error("Failed to update Etherscan key.");
          console.error("Etherscan API error:", err);
        })
        .finally(() => {
          etherscanLoading.value = false;
        });
    };

    // Zapper Form State
    const zapperFormState = reactive({
      uid: "",
      password: "",
    });
    const { resetFields: resetZapperForm } = Form.useForm(zapperFormState);

    const onZapperSubmit = () => {
      zapperLoading.value = true;
      pushZapperCreds(zapperFormState.uid, zapperFormState.password)
        .then(() => {
          message.success("Zapper credentials updated successfully.");
          resetZapperForm();
        })
        .catch((err) => {
          message.error("Failed to update Zapper credentials.");
          console.error("Zapper API error:", err);
        })
        .finally(() => {
          zapperLoading.value = false;
        });
    };

    return {
      etherscanFormState,
      etherscanLoading,
      onEtherscanSubmit,
      zapperFormState,
      zapperLoading,
      onZapperSubmit,
    };
  },
});
</script>
