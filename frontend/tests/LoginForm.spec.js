import { shallowMount, createLocalVue } from '@vue/test-utils';
import LoginForm from '@/components/LoginForm.vue';
import VueRouter from 'vue-router';
import Vuetify from 'vuetify';
import Vue from 'vue';
import { Auth } from 'aws-amplify';

jest.mock('aws-amplify', () => ({
  Auth: {
    signIn: jest.fn(),
  },
}));

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

  it('calls Amplify Auth.signIn and shows success message on valid login', async () => {
    // Mock the success response from Cognito (Amplify Auth)
    Auth.signIn.mockResolvedValue({
      username: 'test@example.com',
    });

    await wrapper.setData({ email: 'test@example.com', password: '1234' });
    const routerPush = jest.spyOn(wrapper.vm.$router, 'push');

    await wrapper.vm.validateForm();

    expect(Auth.signIn).toHaveBeenCalledWith('test@example.com', '1234');
    expect(wrapper.vm.successMessage).toBe('Login successful!');
    expect(sessionStorage.getItem('isLoggedIn')).toBe('true');
    expect(routerPush).toHaveBeenCalledWith('/wishlist');
  });

  it('shows error message on login failure', async () => {
    // Mock the failure response from Cognito (Amplify Auth)
    Auth.signIn.mockRejectedValue(new Error('Invalid credentials'));

    await wrapper.setData({ email: 'test@example.com', password: 'wrong' });
    await wrapper.vm.validateForm();

    expect(wrapper.vm.errorMessage).toBe('Invalid credentials.');
  });

  it('shows error message on network failure', async () => {
    // Mock the network failure
    Auth.signIn.mockRejectedValue(new Error('Network error'));

    await wrapper.setData({ email: 'test@example.com', password: '1234' });
    await wrapper.vm.validateForm();

    expect(wrapper.vm.errorMessage).toBe('Server error or invalid credentials.');
  });
});
