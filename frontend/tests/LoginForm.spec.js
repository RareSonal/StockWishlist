import { shallowMount, createLocalVue } from '@vue/test-utils';
import LoginForm from '@/components/LoginForm.vue';
import VueRouter from 'vue-router';
import Vuetify from 'vuetify';
import Vue from 'vue';
import axios from 'axios';

jest.mock('axios');

Vue.use(Vuetify);
const localVue = createLocalVue();
localVue.use(VueRouter);
const router = new VueRouter();

describe('LoginForm.vue', () => {
  let wrapper;
  let vuetify;

  beforeEach(() => {
    vuetify = new Vuetify();
    wrapper = shallowMount(LoginForm, {
      localVue,
      router,
      vuetify,
    });

    // Clear session before each test
    sessionStorage.clear();
  });

  it('renders email and password input fields', () => {
    const inputs = wrapper.findAllComponents({ name: 'v-text-field' });
    expect(inputs).toHaveLength(2);
  });

  it('shows error if fields are empty on submit', async () => {
    await wrapper.vm.validateForm();
    expect(wrapper.vm.errorMessage).toBe('Email and Password are required!');
  });

  it('calls API and shows success message on valid login', async () => {
    axios.post.mockResolvedValue({ data: { success: true } });

    await wrapper.setData({ email: 'test@example.com', password: '1234' });
    const routerPush = jest.spyOn(wrapper.vm.$router, 'push');

    await wrapper.vm.validateForm();

    expect(axios.post).toHaveBeenCalledWith('http://127.0.0.1:5000/login', {
      email: 'test@example.com',
      password: '1234',
    });

    expect(wrapper.vm.successMessage).toBe('Login successful!');
    expect(sessionStorage.getItem('isLoggedIn')).toBe('true');
    expect(routerPush).toHaveBeenCalledWith('/wishlist');
  });

  it('shows error message on login failure', async () => {
    axios.post.mockResolvedValue({ data: { success: false } });

    await wrapper.setData({ email: 'test@example.com', password: 'wrong' });
    await wrapper.vm.validateForm();

    expect(wrapper.vm.errorMessage).toBe('Invalid credentials.');
  });

  it('shows server error on network failure', async () => {
    axios.post.mockRejectedValue(new Error('Network error'));

    await wrapper.setData({ email: 'test@example.com', password: '1234' });
    await wrapper.vm.validateForm();

    expect(wrapper.vm.errorMessage).toBe('Server error or invalid credentials.');
  });
});
