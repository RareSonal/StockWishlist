module.exports = {
  preset: '@vue/cli-plugin-unit-jest',
  transform: {
    '^.+\\.vue$': '@vue/vue2-jest',
    '^.+\\.js$': 'babel-jest',
  },
  transformIgnorePatterns: [
    '/node_modules/(?!axios|aws-amplify).+\\.js$',
  ],
  moduleFileExtensions: ['js', 'json', 'vue'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  testEnvironment: 'jsdom',

  // Add testMatch to find your tests in "tests/" folder
  testMatch: [
    '**/tests/**/*.spec.[jt]s?(x)',
  ],

  // Optional: Add coverage configuration if needed
  collectCoverage: true,
  collectCoverageFrom: [
    'src/**/*.{js,vue}',
    '!src/main.js', // Exclude entry point file from coverage
    '!src/router.js', // Exclude router.js from coverage
  ],
  coverageDirectory: '<rootDir>/tests/unit/coverage/',
};
