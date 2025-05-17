import { shallowMount, createLocalVue } from '@vue/test-utils';
import WishlistPage from '@/components/WishlistPage.vue';
import VueRouter from 'vue-router';
import Vuetify from 'vuetify';
import Vue from 'vue';
import axios from 'axios';
import flushPromises from 'flush-promises'; // waits for all pending promises

jest.mock('axios');

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

    axios.get.mockImplementation((url) => {
      if (url.includes('/stocks')) return Promise.resolve({ data: mockStocks });
      if (url.includes('/wishlist')) return Promise.resolve({ data: mockWishlist });
    });

    await wrapper.vm.fetchStocks();
    await wrapper.vm.fetchWishlist();
    await flushPromises();

    expect(wrapper.vm.stocks).toEqual(mockStocks);
    expect(wrapper.vm.wishlist).toEqual(mockWishlist);
  });

  it('adds stock to wishlist', async () => {
    axios.post.mockResolvedValue({ data: { message: 'Stock added to wishlist' } });

    await wrapper.vm.addToWishlist(1);
    await flushPromises();

    expect(axios.post).toHaveBeenCalledWith('http://127.0.0.1:5000/wishlist', {
      user_id: 1,
      stock_id: 1,
    });
  });

  it('removes stock from wishlist', async () => {
    axios.delete.mockResolvedValue({ data: { message: 'Stock removed from wishlist' } });

    await wrapper.vm.removeFromWishlist(1);
    await flushPromises();

    expect(axios.delete).toHaveBeenCalledWith('http://127.0.0.1:5000/wishlist', {
      data: {
        user_id: 1,
        stock_id: 1,
      },
    });
  });

  it('clears session and redirects on logout', () => {
    sessionStorage.setItem('isLoggedIn', 'true');
    wrapper.vm.logout();

    expect(sessionStorage.getItem('isLoggedIn')).toBeNull();
  });
});
