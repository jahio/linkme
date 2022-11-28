<template>
  <div class="RedirectView">
    <img alt="Vue logo" src="../assets/logo.png">
    <ExistingLink />
  </div>
</template>

<script>
// @ is an alias to /src
import ExistingLink from '@/components/ExistingLink.vue'
import LinkService from '@/services/LinkService.js'

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
    LinkService.get(this.$route.params.shortpath).then(response => {
      console.log('events:', response.data)
    })
    .catch(error => {
      console.log(error)
    })
  }
}
</script>
