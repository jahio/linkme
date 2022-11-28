import axios from 'axios'

const linkService = axios.create({
  baseURL: 'http://localhost:3000/',
  withCredentials: false,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }
})

export default {
  get(shortcode) {
    return linkService.get(`/links/${shortcode}`)
  },
  create(url) {
    return linkService.post('/links', { link: { url: url } } )
  }
}
