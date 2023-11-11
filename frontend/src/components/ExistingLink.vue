<template>
  <div class="ExistingLink">
    <p>{{short_link}} corresponds to...</p>
    <h2>
      <a :href="original_url">{{ original_url }}</a>
    </h2>

    <p>
      Redirecting you momentarily...
    </p>

    <p class="small">
      ...or just click the link if you're impatient and certain the domain is safe to visit.
    </p>

  </div>
</template>

<script>
  import LinkService from '@/services/LinkService.js'
  export default {
    name: 'ExistingLink',
    data() {
      return {
        original_url: null,
        short_link: null,
        shortpath: null,
        error: null
      }
    },
    created() {
      LinkService.get(this.$route.params.shortpath).then(response => {
        console.log('events:', response.data)
        this.original_url = response.data.original_url
        this.short_link = response.data.short_link
        this.shortpath = response.data.shortpath
        // Set a timeout and then when finished, redirect to the location.
        // Five seconds.
        // setTimeout(()=> {
        //   window.location.replace(this.original_url)
        // }, 5000)
      })
      .catch(error => {
        console.log(error)
        this.error = error
      })
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
