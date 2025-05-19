import Vue from 'vue';
import Router from 'vue-router';
import { Auth } from 'aws-amplify';
import LoginForm from './components/LoginForm.vue';
import Wishlist from './components/WishlistPage.vue';

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
router.beforeEach(async (to, from, next) => {
  try {
    const user = await Auth.currentAuthenticatedUser(); // Get the current authenticated user

    // If trying to access a route that requires authentication but the user is not logged in
    if (to.matched.some(record => record.meta.requiresAuth) && !user) {
      next('/login');  // Redirect to login if not authenticated
    } 
    // If already logged in and trying to access the login page, redirect to wishlist
    else if (to.path === '/login' && user) {
      next('/wishlist');
    } 
    else {
      next();  // Proceed with navigation
    }
  } catch (error) {
    // If no user is authenticated, we redirect to login
    if (to.matched.some(record => record.meta.requiresAuth)) {
      next('/login');
    } else {
      next();
    }
  }
});

export default router;
