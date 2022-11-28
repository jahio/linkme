<template>
  <div class="NewLink">
    <form class="new-link-form" @submit.prevent="onSubmit">
      <p><label for="original_url">Shorten This:</label></p>
      <p><input id="original_url" v-model="original_url" placeholder="Enter URL Here"></p>
      <p><input class="button" type="submit" value="Link me!"></p>
    </form>
  </div>
</template>

<script>
  import LinkService from '@/services/LinkService.js'
  export default {
    name: 'NewLink',
    data() {
      return {
        original_url: null,
        short_link: null,
        shortpath: null,
        error: null
      }
    },
    methods: {
      onSubmit() {
        LinkService.create(this.original_url).then(response => {
          this.short_link = response.data.short_link
          this.shortpath = response.data.shortpath
          console.log(response.data)
          // Sort of a hack, but feasibility...
          // Redirect to the location for the shortened link
          window.location.replace(`${window.location.origin}/${this.shortpath}`)
        })
        .catch(error => {
          console.log(error) // TODO: Formal error-handling presented to the user
        })
      }
    }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
