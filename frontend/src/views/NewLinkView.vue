<template>
  <div class="NewLink">
    <img alt="Vue logo" src="../assets/logo.png">
    <NewLink />
  </div>
</template>

<script>
// @ is an alias to /src
import NewLink from '@/components/NewLink.vue'

export default {
  name: 'NewLinkView',
  components: {
    NewLink
  }
}
</script>
