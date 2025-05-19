import Vue from 'vue';
import VueRouter from 'vue-router';
import { Auth } from 'aws-amplify';

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
    component: WishlistPage,
    meta: { requiresAuth: true }
  }
];

const router = new VueRouter({
  mode: 'history',
  routes
});

// Global navigation guard
router.beforeEach(async (to, from, next) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);

  if (!requiresAuth) {
    return next();
  }

  try {
    await Auth.currentAuthenticatedUser();
    next();
  } catch (err) {
    next('/login');
  }
});

export default router;
