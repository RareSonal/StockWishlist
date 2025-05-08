// src/router.js
import Vue from 'vue';
import Router from 'vue-router';
import LoginForm from './components/LoginForm.vue';
import Wishlist from './components/WishlistPage.vue'; // Assuming you have one

Vue.use(Router);

const router = new Router({
  mode: 'history',
  routes: [
    { 
      path: '/login', 
      component: LoginForm, 
      meta: { requiresAuth: false } // Login route, no auth required
    },
    { 
      path: '/wishlist', 
      component: Wishlist, 
      meta: { requiresAuth: true } // Wishlist route, requires authentication
    },
    { 
      path: '*', 
      redirect: '/login' // Default fallback
    }
  ]
});

// Navigation guard to handle redirects based on authentication state
router.beforeEach((to, from, next) => {
  const isAuthenticated = sessionStorage.getItem('isLoggedIn');

  // If trying to access a route that requires authentication but the user is not logged in
  if (to.matched.some(record => record.meta.requiresAuth) && !isAuthenticated) {
    next('/login');  // Redirect to login if not authenticated
  } 
  // If already logged in and trying to access the login page, redirect to wishlist
  else if (to.path === '/login' && isAuthenticated) {
    next('/wishlist');
  } 
  else {
    next();  // Proceed with navigation
  }
});

export default router;
