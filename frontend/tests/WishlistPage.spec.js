import { shallowMount, createLocalVue } from '@vue/test-utils';
import WishlistPage from '@/components/WishlistPage.vue';
import VueRouter from 'vue-router';
import Vuetify from 'vuetify';
import Vue from 'vue';
import { Auth } from 'aws-amplify';
import { API } from 'aws-amplify';  // Assuming API is used for interacting with your API Gateway

jest.mock('aws-amplify', () => ({
  Auth: {
    currentSession: jest.fn(),
    signOut: jest.fn(),
  },
  API: {
    get: jest.fn(),
    post: jest.fn(),
    del: jest.fn(),
  },
}));

Vue.use(Vuetify);
const localVue = createLocalVue();
localVue.use(VueRouter);
const router = new VueRouter();

describe('WishlistPage.vue', () => {
  let wrapper;
  let vuetify;

  beforeEach(() => {
    vuetify = new Vuetify();
    wrapper = shallowMount(WishlistPage, {
      localVue,
      router,
      vuetify,
    });

    // Suppress console errors from axios in test logs
    jest.spyOn(console, 'error').mockImplementation(() => {});
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('fetches stocks and wishlist on mount', async () => {
    const mockStocks = [{ id: 1, name: 'AAPL', quantity: 5 }];
    const mockWishlist = [{ user_id: 1, stock_id: 1, name: 'AAPL' }];

    // Mocking the API calls
    API.get.mockImplementation((apiName, path) => {
      if (path.includes('/stocks')) return Promise.resolve(mockStocks);
      if (path.includes('/wishlist')) return Promise.resolve(mockWishlist);
    });

    await wrapper.vm.fetchStocks();
    await wrapper.vm.fetchWishlist();

    expect(wrapper.vm.stocks).toEqual(mockStocks);
    expect(wrapper.vm.wishlist).toEqual(mockWishlist);
  });

  it('adds stock to wishlist', async () => {
    const mockResponse = { message: 'Stock added to wishlist' };

    API.post.mockResolvedValue(mockResponse);

    await wrapper.vm.addToWishlist(1);

    expect(API.post).toHaveBeenCalledWith('wishlist', {
      user_id: 1,
      stock_id: 1,
    });
  });

  it('removes stock from wishlist', async () => {
    const mockResponse = { message: 'Stock removed from wishlist' };

    API.del.mockResolvedValue(mockResponse);

    await wrapper.vm.removeFromWishlist(1);

    expect(API.del).toHaveBeenCalledWith('wishlist', {
      body: { user_id: 1, stock_id: 1 },
    });
  });

  it('clears session and redirects on logout', async () => {
    sessionStorage.setItem('isLoggedIn', 'true');
    
    // Mocking the Auth signOut method
    Auth.signOut.mockResolvedValue();

    await wrapper.vm.logout();

    expect(sessionStorage.getItem('isLoggedIn')).toBeNull();
    expect(Auth.signOut).toHaveBeenCalled();
    expect(wrapper.vm.$router.push).toHaveBeenCalledWith('/login');
  });
});
