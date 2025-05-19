module.exports = {
  presets: [
    // Vue preset for Vue 2.x compatibility
    '@vue/babel-preset-app',

    // Ensure compatibility with modern JavaScript features in all browsers (useful for production builds)
    ['@babel/preset-env', {
      targets: '> 0.25%, not dead', // Set appropriate browser support for your app
      useBuiltIns: 'usage',
      corejs: 3, // Include polyfills for core-js v3
    }]
  ],
  plugins: [
    // Enable the class properties plugin if you want to use ES class properties
    '@babel/plugin-proposal-class-properties',

    // Enable optional chaining (?.) for easier null/undefined checking
    '@babel/plugin-proposal-optional-chaining',

    // Enable nullish coalescing (??) support for handling nullish values
    '@babel/plugin-proposal-nullish-coalescing-operator',

    // Add the transform-runtime plugin for handling runtime polyfills (important for newer JS features)
    '@babel/plugin-transform-runtime',

    // Add support for dynamic import if you’re using Vue Router or other code-splitting features
    '@babel/plugin-syntax-dynamic-import'
  ]
};
