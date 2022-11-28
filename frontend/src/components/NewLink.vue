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
        original_url: '',
        short_link: '',
        shortpath: ''
      }
    },
    methods: {
      onSubmit() {
        LinkService.create(this.original_url).then(response => {
          console.log(response.data)
          this.short_link = response.data.short_link
          this.shortpath = response.data.shortpath
        })
        .catch(error => {
          console.log(error)
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
