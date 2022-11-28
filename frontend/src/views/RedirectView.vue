<template>
  <div class="RedirectView">
    <img alt="Vue logo" src="../assets/logo.png">
    <ExistingLink />
  </div>
</template>

<script>
// @ is an alias to /src
import ExistingLink from '@/components/ExistingLink.vue'
import axios from 'axios'

export default {
  name: 'RedirectView',
  components: {
    ExistingLink
  },
  data() {
    return {
      link: null
    }
  },
  created() {
    axios.defaults.headers.common['Content-Type'] = 'application/json'
    axios.defaults.headers.common['Accept'] = 'application/json'
    axios.get("http://localhost:3000/links/SHORTCODE").then(response => {
      console.log('events:', response.data)
    })
    .catch(error => {
      console.log(error)
    })
  }
}
</script>
