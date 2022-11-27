import { createRouter, createWebHistory } from 'vue-router'
import NewLinkView from '../views/NewLinkView.vue'
import RedirectView from '../views/RedirectView.vue'

const routes = [
  {
    path: '/',
    name: 'new',
    component: NewLinkView
  },
  {
    path: '/:shortpath',
    name: 'redirect',
    component: RedirectView
  }
  // {
  //   path: '/',
  //   name: 'home',
  //   component: HomeView
  // },
  // {
  //   path: '/about',
  //   name: 'about',
  //   // route level code-splitting
  //   // this generates a separate chunk (about.[hash].js) for this route
  //   // which is lazy-loaded when the route is visited.
  //   component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue')
  // }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
