<template>
  <div class="hello">
    <img alt="Vue logo" src="@/assets/logo.png">
    <h1>{{ msg }}</h1>

    <div  class="content">
      <div>
        <div class="blog-body">
          Here is a simple example using web3://. This example implements a
          message board where anyone can send messages to the contract to leave a message.
          <p>Command:</p>
          <p style="background: #CCCCCC; color: green; padding: 3px">
            cast send 0xc6c3777261352BE0071e3e15263EB105096485E5 "writeMessage(string)" "YOUR_MESSAGE_CONTENT" --private-key YOUR_PRIVATE_KEY -r http://65.109.20.29:8545
          </p>
        </div>

        <div class="comment-card">
          <h3 style="text-align: left">Message Board</h3>
          <div v-for="(item, index) in messages" :key="item.timestamp" class="comment">
            <div class="comment-header">
              <div style="font-size: 14px">ID: {{ messages.length - index }}</div>
              <div style="font-size: 12px">Author: {{ item.user }}</div>
            </div>
            <div class="comment-driver"/>
            <p class="comment-content">{{ item.content }}</p>
            <div class="comment-time">
              <div style="font-size: 12px; color: #CCCCCC">
                Time: {{ renderTimestamp(new Date(item.timestamp)) }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="footer">
      <div class="footer-layout">
        <el-row>
          <a href="https://github.com/ethstorage/hello-web3" target="_blank">
            <img class="footer-img" src="@/assets/git.png">
          </a>
          <a href="https://twitter.com/EthStorage" target="_blank">
            <img class="footer-img" src="@/assets/tweet.png">
          </a>
          <a href="https://ethstorage.medium.com/" target="_blank">
            <img class="footer-img" src="@/assets/mid.png">
          </a>
          <a href="https://t.me/ethstorage" target="_blank">
            <img class="footer-img" src="@/assets/tel.png">
          </a>
          <a href="https://discord.gg/xhCwaMp7ps" target="_blank">
            <img class="footer-img" src="@/assets/dis.png">
          </a>
        </el-row>
      </div>
    </div>
  </div>
</template>

<script>
import { ethers } from "ethers";

const MessagesAbi = [
  "function getMessages() public view returns (bytes[] memory contents, bytes[] memory users, bytes[] memory timestamps)"
];
const ContractAddress = "0xc6c3777261352BE0071e3e15263EB105096485E5";
const RPC  = "https://rpc.testnet.l2.quarkchain.io:8545";

const hexToString = (h) => ethers.toUtf8String(h);

export default {
  name: 'HelloWorld',
  data() {
    return {
      messages: [],
    }
  },
  props: {
    msg: String
  },
  methods: {
    renderTimestamp(ts) {
      if (!ts) {
        return "";
      }
      return ts.toLocaleDateString(undefined, {
        day: "numeric",
        month: "short",
        year: "numeric",
      });
    },
    async loadData() {
      const provider = new ethers.JsonRpcProvider(RPC);
      const contract = new ethers.Contract(ContractAddress, MessagesAbi, provider);
      const data = await contract.getMessages();
      if (data) {
        const contents = data[0];
        const users = data[1];
        const timestamps = data[2];
        for (let i = 0; i < timestamps.length; i++) {
          const time = hexToString(timestamps[i]).trim().replace("\u0000", "");
          this.messages.push({
            content: hexToString(contents[i]) || "<empty>",
            timestamp: Number(time) * 1000,
            user: users[i]
          });
        }
        this.messages.sort(function (a, b) {
          return b.timestamp - a.timestamp
        });
      }
    }
  },
  mounted() {
    this.loadData();
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.hello {
  margin-top: 60px;
  width: 100%;
  height: 100%;
}

.content {
  width: 1000px;
  margin: 0 auto;
}

.blog-body {
  margin: 35px 0;
  border: 1px solid #CCCCCC50;
  padding: 15px;
  text-align: left;
  font-size: 16px;
  color: black;
}


.comment-card {
  margin: 35px 0;
  border: 1px solid #CCCCCC50;
  padding: 15px
}
.comment {
  border: 1px solid #0087FF50;
  padding: 15px;
  margin-bottom: 10px
}
.comment-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between
}
.comment-driver {
  width: 100%;
  height: 1px;
  background: #1B60FF25;
  margin: 15px 0
}
.comment-content {
  font-size: 14px;
  color: black;
}
.comment-time {
  display: flex;
  flex-direction: row-reverse;
  margin: 20px 0 0;
}

.footer {
  padding: 30px !important;
  height: 95px !important;
  background: transparent;
}

.footer-layout {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.footer-img {
  width: 36px;
  margin: 0 10px;
}
</style>
