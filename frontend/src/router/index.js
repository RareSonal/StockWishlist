import Vue from 'vue';
import VueRouter from 'vue-router';

import WishlistPage from '@/components/WishlistPage.vue';
import LoginForm from '@/components/LoginForm.vue';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginForm
  },
  {
    path: '/wishlist',
    name: 'Wishlist',
    component: WishlistPage
  }
];

const router = new VueRouter({
  mode: 'history',
  routes
});

export default router;
