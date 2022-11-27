<template>
  <div class="RedirectView">
    <img alt="Vue logo" src="../assets/logo.png">
    <ExistingLink />
  </div>
</template>

<script>
// @ is an alias to /src
import ExistingLink from '@/components/ExistingLink.vue'

export default {
  name: 'RedirectView',
  components: {
    ExistingLink
  }
}
</script>
